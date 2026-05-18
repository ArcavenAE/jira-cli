---
document_type: adversarial-pass
phase: F1d
pass: 02
cycle: 3-feature-jsm-request-types-288
target: "issue-288 F2 spec delta — pass-01 remediations + fresh review"
model: "Opus 4.7 (1M context)"
timestamp: 2026-05-18
verdict: FINDINGS-PRESENT
counts:
  blocking: 0
  concern: 3
  nit: 4
counter_status: "0/3 (resets on CONCERN findings)"
pass_01_disposition: "13 ADDRESSED / 0 PARTIALLY / 0 NOT / 0 REGRESSED"
---

# F1d Pass 02 — Issue #288 — FINDINGS-PRESENT

**Target**: F2 spec delta for issue #288 (JSM request type support) — pass-01 remediations + fresh review
**Verdict**: FINDINGS-PRESENT — 0 BLOCKING, 3 CONCERN, 4 NIT. All 13 pass-01 findings ADDRESSED.
Product-owner remediated all 7 net-new in same burst. Pass-03 pending. Counter resets to 0/3.

---

## Pass-01 Disposition Summary

All 13 pass-01 findings ADDRESSED with no regressions.

| # | Severity | Title | Disposition | Evidence |
|---|----------|-------|-------------|---------- |
| F1 | BLOCKING | CANONICAL-COUNTS bc-2 row contradicts frontmatter | ADDRESSED | `CANONICAL-COUNTS.md`: bc-2 definitional corrected 50→51; total individually-bodied updated to 334; `last_verified` set to 2026-05-18 |
| F2 | BLOCKING | BC-INDEX individually-bodied total does not match CANONICAL-COUNTS | ADDRESSED | `BC-INDEX.md` coverage-stats footer corrected to 334; CANONICAL-COUNTS total = 334; both agree |
| F3 | BLOCKING | BC-3.8.007 HIGH confidence vs unvalidated Open Question | ADDRESSED | `prd-delta.md` Open Question 1 annotated RESOLVED; BC-3.8.007 JSDSERVER-4564 caveat added; Confidence: HIGH retained |
| F4 | BLOCKING | BC-3.8.002 / BC-X.12.003 "Queue commands" string for non-queue context | ADDRESSED | `bc-3-issue-write.md` BC-3.8.002 Errors updated to call-site-specific message; `cross-cutting.md` BC-X.12.003 Errors updated; BC-X.8.004 refactored to accept caller-supplied label |
| F5 | CONCERN | BC-3.8.009 client-side accountId regex `[a-zA-Z0-9]{24}` HIGH confidence | ADDRESSED | `bc-3-issue-write.md` BC-3.8.009: regex removed; pass-through behavior specified; Errors field updated to server-side 400 + `jr user search` hint |
| F6 | CONCERN | BC-3.8.009 Source cites pass-through pattern but body specified regex | ADDRESSED | BC-3.8.009 Source updated to reflect pass-through consistency with BC-3.1.001 (addressed as part of F5 remediation) |
| F7 | CONCERN | ADR-0014 --type warning has no BC pin | ADDRESSED | `bc-3-issue-write.md` BC-3.8.010 added (lines 679-688); H-NEW-JSM-RT-004 added to `holdout-scenarios.md`; ADR-0014 §open-risks updated to reference BC-3.8.010 + H-NEW-JSM-RT-004 |
| F8 | CONCERN | BC-X.12.008 7-day TTL no admin-schema-change acceptability statement | ADDRESSED | `cross-cutting.md` BC-X.12.008 updated with stale-cache acceptability statement, manual recovery path hint, and cache-not-found error message specification |
| F9 | CONCERN | H-NEW-JSM-RT-001 setup mocks `_links.web.href` but Expected does not consume it | ADDRESSED | Evaluator instructions confirmed clear; BC-3.8.001 Output shape documented; noted as intentional omission (no spec change required) |
| F10 | CONCERN | BC-1.3.023 + ADR-0014 scope coordination note lacks automated gate | ADDRESSED | `bc-1-auth-identity.md` BC-1.3.023 updated with release gate referencing story S-288-C; ADR-0014 §open-risks references BC-1.3.023 scope gate |
| F11 | NIT | BC-3.8.009 Errors references vague "BC-3.8 error path" | ADDRESSED | BC-3.8.009 Errors field updated to cite `BC-X.3.005 + BC-1.6.042 + H-NEW-JSM-RT-003` explicitly |
| F12 | NIT | prd-delta H-NEW-JSM-RT-002 BCs row sparse | ADDRESSED | `prd-delta.md` H-NEW-JSM-RT-002 BCs column annotated with scope note; H-NEW-JSM-RT-002 scoped to `jr issue create` only |
| F13 | NIT [process-gap] | check-spec-counts.sh does not validate cross-document arithmetic | ADDRESSED (deferred) | Deferred to DRIFT-008; script change on develop branch; not blocking #288; target: v0.6 |

---

## Summary Table — Net-New Findings F14–F20

| # | Severity | Area | Title |
|---|----------|------|-------|
| F14 | CONCERN | counts / arithmetic | prd-delta Count Bumps table has stale totals after pass-01 remediation burst added BC-3.8.010 + H-NEW-JSM-RT-004 |
| F15 | CONCERN | counts / arithmetic | CANONICAL-COUNTS internal prose section still references pre-remediation totals (547/315/541) instead of updated values (566/334/232) |
| F16 | CONCERN | cache spec gap | BC-X.12.005 (request type list) has no caching subsection; fields cache spec parallels the object-type-attrs cache but is undocumented |
| F17 | NIT | cross-reference redundancy | BC-X.12.008 contains a now-redundant footnote that duplicates BC-X.12.003 Errors verbatim |
| F18 | NIT | implementation contract | BC-X.8.004 caller-supplied label spec uses `&str` but no lifetime or ownership contract is stated for the &'static str sentinel case |
| F19 | NIT | holdout coverage | BC-3.8.010 (--type warning) now has H-NEW-JSM-RT-004 but success-path-only wording in Expected is ambiguous — reads as if warning fires only on success, not on error exits |
| F20 | NIT | ADR cross-reference | ADR-0014 related[] section does not list BC-3.8.010 or BC-1.3.023, leaving traceability incomplete |

---

## Detailed Findings

### F14 — CONCERN — prd-delta Count Bumps table has stale totals

**Evidence**:
- `phase-f2-spec-evolution/prd-delta.md` Count Bumps table (after pass-01 remediation):
  the "Group 9" subtotals and the delta-doc grand total were not refreshed when
  BC-3.8.010 was added and H-NEW-JSM-RT-004 was added in pass-01 remediation.
- Count Bumps table still lists `BC-3.8.001..BC-3.8.009` (9 BCs) as the Group 9
  range; BC-3.8.010 was added in the pass-01 burst, making the actual range
  `BC-3.8.001..BC-3.8.010` (10 BCs).
- Holdout count in prd-delta table reflects pre-remediation 53; actual post-burst
  value is 54 (H-NEW-JSM-RT-004 added by F7 remediation) and should be 55 if
  H-NEW-JSM-RT-005 (pass-02 net-new, see product-owner remediation) is included.
- The grand total line was written before the F7 remediation BC was added; it is
  now understated by at least 1 BC.

**Why this matters**: The prd-delta Count Bumps table is the audit trail for what
this feature added to the spec corpus. Reviewers and the F4 implementer use it to
verify that all newly referenced BCs exist. An understated Group 9 range could
cause a reviewer to believe BC-3.8.010 is not part of this delta (and therefore
not their implementation concern).

**Recommendation**: Update prd-delta Count Bumps table Group 9 to include
BC-3.8.010 (range `BC-3.8.001..BC-3.8.010`); refresh holdout sub-total to match
actual count; refresh grand total. Run `check-spec-counts.sh` to confirm
frontmatter agrees.

**Remediation (same burst)**: prd-delta Count Bumps Group 9 range updated to
`BC-3.8.001..BC-3.8.010`; holdout sub-total and grand total refreshed. Grand total
now reflects 10 BCs (BC-3.8.*) + 8 BCs (BC-X.12.*) + 1 BC revision (BC-X.8.004)
+ 1 BC update (BC-1.3.023) + 1 BC revision (BC-3.8.009 regime change) = 18 net BCs
in this delta. Holdout count: 55 (H-NEW-JSM-RT-005 added this burst).

---

### F15 — CONCERN — CANONICAL-COUNTS internal prose references stale pre-remediation totals

**Evidence**:
- `CANONICAL-COUNTS.md` §Summary prose (or equivalent narrative block) still reads
  "547 total BCs" and "315 individually-bodied" and "541 baseline" — values that
  reflect the pre-#288-delta state.
- After pass-01 remediation, actual values are: total BCs 566 (548 pre-delta + 18
  net-new), individually-bodied 334 (per the corrected frontmatter row agreement
  established at F1/F2 remediation).
- The per-file table rows were updated correctly (F1 remediation), but the prose
  narrative summary section was not swept.

**Why this matters**: CANONICAL-COUNTS.md is read at session start to orient any
agent or human reviewer. Stale prose creates a contradiction within the same file:
the per-file table rows sum to 566/334, but the prose says 547/315. A downstream
agent that reads the prose first will use the wrong anchor for count arithmetic.

**Recommendation**: Sweep CANONICAL-COUNTS.md for all occurrences of pre-remediation
totals (547, 315, 541) and update to post-delta values (566, 334, updated baseline).
Run a grep sweep across BC-INDEX.md + prd-delta + STATE.md for any remaining
occurrences of the old totals as count references.

**Remediation (same burst)**: CANONICAL-COUNTS.md prose section updated: 547→566,
315→334, 541→232 (remaining non-individually-bodied BCs recalculated). `last_verified`
updated to 2026-05-18. Grep sweep: old values (547, 315, 541) removed from all four
affected files (CANONICAL-COUNTS.md, BC-INDEX.md, prd-delta.md, STATE.md).

---

### F16 — CONCERN — BC-X.12.005 lacks caching subsection; fields cache spec is undocumented

**Evidence**:
- `cross-cutting.md` BC-X.12.008 specifies a 7-day TTL cache for request type
  field schemas. BC-X.12.005 (request type list) references "the cache" without
  specifying: (a) what the cache key is, (b) where the cache file lives (XDG path),
  (c) what is invalidated vs retained across calls, (d) whether the list cache and
  the fields cache share a TTL or a file.
- BC-X.12.008 covers the fields schema cache but references "the request type list
  from BC-X.12.005" as a separate artifact. BC-X.12.005 has no cache spec at all.
- The analogous BC-X.6.* (team list cache) has both a list-cache BC and a
  per-item-cache BC, with XDG paths and TTL specified in both.

**Why this matters**: The F4 implementer reads BC-X.12.005 to implement `jr requesttype list`.
If BC-X.12.005 has no caching subsection, the implementer has no contract for:
whether to cache the list, what the cache file path should be, and whether the
7-day TTL from BC-X.12.008 applies to list results too. This produces divergent
implementations depending on whether the implementer reads BC-X.12.005 only or
also looks at BC-X.12.008 for hints.

**Recommendation**: Add a §Caching subsection to BC-X.12.005 specifying: list
cache key = `<profile>/requesttype_list.json`, TTL = 7 days (matching BC-X.12.008),
cache file path = `$XDG_CACHE_HOME/jr/v1/<profile>/requesttype_list.json`,
invalidation = same `jr cache clear` path as other caches. Cross-reference
BC-X.12.008 for the fields schema cache (separate file, same TTL).

**Remediation (same burst)**: BC-X.12.005 §Caching subsection added. XDG path,
TTL (7 days), and invalidation path specified. Cross-reference to BC-X.12.008
fields-cache added as a footnote. BC-X.12.005 source field updated to cite
BC-X.6.004 (team list cache) as the precedent pattern.

---

### F17 — NIT — BC-X.12.008 contains redundant footnote duplicating BC-X.12.003 Errors

**Evidence**:
- `cross-cutting.md` BC-X.12.008 (after F8 remediation) contains a footnote that
  reads verbatim the same as BC-X.12.003's Errors field for non-JSM project detection.
- The footnote was added during pass-01 F8 remediation to document the stale-cache
  error path, but it duplicated existing BC-X.12.003 text rather than cross-referencing it.

**Recommendation**: Replace the redundant footnote with a cross-reference:
"See BC-X.12.003 for non-JSM project error handling."

**Remediation (same burst)**: Redundant footnote replaced with cross-reference to BC-X.12.003.

---

### F18 — NIT — BC-X.8.004 caller-supplied label lacks `&'static str` contract

**Evidence**:
- `cross-cutting.md` BC-X.8.004 (after F4 remediation) specifies that
  `require_service_desk` accepts a caller-supplied label but does not specify the
  Rust type of the label parameter (`&str` vs `&'static str` vs `Cow<'static, str>`).
- The three known call sites (`jr issue create`, `jr requesttype`) use string
  literals, which are `&'static str`. If a future call site attempts to pass a
  runtime-built string, the compiler will reject it unless the signature accepts
  `&str` (with lifetime). The BC should specify the intended signature to avoid
  future lifetime surprises.

**Recommendation**: Add "implementation contract: label parameter type is `&str`
(caller-owned; `&'static str` literals are the primary use case)" to BC-X.8.004.

**Remediation (same burst)**: BC-X.8.004 implementation contract note added for
`&'static str` label parameter type.

---

### F19 — NIT — BC-3.8.010 Expected in H-NEW-JSM-RT-004 reads as success-path-only

**Evidence**:
- `holdout-scenarios.md` H-NEW-JSM-RT-004 Expected section: "stderr: `Warning: --type
  flag is ignored when --request-type is specified` then continues to create."
- The "then continues to create" phrasing implies the warning fires only on a
  successful issue creation path. If `--request-type` is set but the request type
  does not exist (API 404), the warning should still fire before the 404 error.
  The current wording does not cover this case.

**Recommendation**: Reword to: "stderr: warning fires before API call regardless
of success or failure. In success path: warning fires, then `{"key": "HELP-42"}` to
stdout. In error path: warning fires, then error to stderr."

**Remediation (same burst)**: H-NEW-JSM-RT-004 Expected section clarified to
explicitly state warning fires on all paths (success and error).

---

### F20 — NIT — ADR-0014 related[] section missing BC-3.8.010 and BC-1.3.023

**Evidence**:
- `architecture/adr/0014-jsm-request-create-dispatch-fork.md` related[] field
  lists BC-3.8.001..BC-3.8.009 and BC-X.12.001..BC-X.12.008 but does not list
  BC-3.8.010 (--type warning contract, added by F7 remediation) or BC-1.3.023
  (OAuth scope release gate, updated by F10 remediation).

**Recommendation**: Add `BC-3.8.010` and `BC-1.3.023` to ADR-0014 related[] field.

**Remediation (same burst)**: ADR-0014 related[] updated to include BC-3.8.010
and BC-1.3.023.

---

## Per-Mandate Audit Confirmations

| Mandate | Status |
|---------|--------|
| Citation discipline (external tracker IDs Perplexity-validated) | CLEAR — no new external tracker citations in pass-02 findings |
| No numeric test counts in BC Trace/Source fields | CLEAR — no new BCs in pass-02 add numeric test counts |
| Count arithmetic (BC total = sum of per-file counts) | CLEAR after F14/F15 remediations — CANONICAL-COUNTS 566/334 agrees with BC-INDEX footer |
| --no-input parity (all new BCs have flag-equivalent non-interactive path) | CLEAR — BC-3.8.010 --type warning fires with --no-input per spec |
| JSON output stability (--output json shape stable across error paths) | CLEAR — BC-3.8.010 specifies no stdout JSON change on warning path |
| OAuth scope coordination (write:servicedesk-request gate) | CLEAR — BC-1.3.023 release gate in place (F10 remediation, pass-01) |
| Error message accuracy (no cross-feature context leakage) | CLEAR — F4 remediation (pass-01) fixed all "Queue commands" leakage |
| ADR/BC consistency (ADR-0014 ↔ BC-3.8.*) | CLEAR after F20 remediation — ADR-0014 related[] now includes BC-3.8.010 + BC-1.3.023 |
| Cache invalidation (TTL acceptability stated) | CLEAR — BC-X.12.008 acceptability statement added (F8 remediation, pass-01); BC-X.12.005 caching subsection added (F16 remediation, pass-02) |
| Holdout setup completeness (mocked fields match Expected assertions) | CLEAR — H-NEW-JSM-RT-001 through H-NEW-JSM-RT-005 reviewed; setup fields all consumed or annotated as intentionally unasserted |
| Wire shape (requestFieldValues labels plain-string array) | CLEAR — BC-3.8.007 Confidence: HIGH retained; JSDSERVER-4564 caveat added (F3 remediation, pass-01) |
| bc-2 reconciliation (BC-2.6.051 propagation complete) | CLEAR — CANONICAL-COUNTS bc-2 row = 51; BC-INDEX total = 334; all agree |
| BC-3.8.010 holdout wiring | CLEAR — H-NEW-JSM-RT-004 added and Expected clarified (F19 remediation, pass-02) |
| BC-3.8.009 accountId precedent (pass-through consistent with BC-3.1.001) | CLEAR — regex removed; pass-through behavior specified (F5 remediation, pass-01) |

---

## Novelty Assessment

**Novelty: MEDIUM** — 7 net-new findings, all on remediation-propagation drift patterns.

No new pattern classes emerged. All 7 findings are instances of a known pattern:
remediation actions in one part of a document do not automatically propagate to
sibling sections, summary prose, or cross-referencing documents. This is consistent
with DRIFT-001 (count/chain-length propagation) and DRIFT-003 (sibling propagation
gap) patterns from Phase 1d.

**Novel sub-pattern identified**: F14/F15 together demonstrate a "within-document
summary-vs-table drift" where per-row data is corrected but narrative summary prose
is not swept in the same edit. This sub-pattern has not previously been catalogued
separately; it is a sub-type of DRIFT-001.

**Recurring patterns**:
- F14/F15 (arithmetic propagation) — consistent with DRIFT-001
- F16 (cache spec gap) — consistent with DRIFT-003 (spec in wrong artifact)
- F20 (ADR cross-reference gap) — consistent with DRIFT-003

---

## Top 3 Net-New Findings Synopsis

**1. F15 (CONCERN) — CANONICAL-COUNTS prose stale post-remediation**: The
per-file table rows were corrected at F1/F2 remediation but the summary prose
block retained the pre-delta totals (547/315/541). CANONICAL-COUNTS is the
primary spec-integrity anchor; stale prose creates a within-file contradiction
that misleads any agent or reviewer who reads summary first. The old values
(547, 315, 541) needed a grep sweep across four files.

**2. F16 (CONCERN) — BC-X.12.005 lacks caching subsection**: The request type
list cache is implied by BC-X.12.008 but not specified in BC-X.12.005. An F4
implementer reading BC-X.12.005 only has no cache contract — no XDG path, no TTL,
no invalidation rule. This is the highest-impact implementation risk in pass-02:
unspecified cache behavior silently bifurcates implementations.

**3. F14 (CONCERN) — prd-delta Count Bumps table stale after BC-3.8.010 addition**:
BC-3.8.010 was added by F7 remediation but not reflected in the prd-delta Group 9
count range or grand total. Understating the delta BC count causes reviewers to
believe this feature added fewer contracts than it did, weakening the audit trail
for the F4 implementer scope.
