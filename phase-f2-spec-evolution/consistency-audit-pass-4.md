---
document_type: consistency-audit
bundle: DEAD-CITATION-CI
phase: F2
iteration: 4
auditor: consistency-validator
created: 2026-06-19
scope: pass-4 — fresh-context audit after F2-Iter5 pipeline restructuring from (a)–(h) to merged (a)–(e)
verdict: INCONSISTENT (8 MINOR findings; 0 MAJOR findings)
---

# F2 Consistency Audit — DEAD-CITATION-CI (Pass 4)

**Scope:** Fresh-context audit of the canonical (a)–(e) pipeline restructuring
(F2-Iter5, F-PASS6-01 fix). The PO claims all documents were re-synced. Verify:
(1) step-scheme consistency across BC body, arch-delta, verification-delta, prd-delta;
(2) count integrity 602/370/232; (3) CI-CITE-001 failure message single-source-of-truth;
(4) new EC-CITE-026/027/028 and existing ECs reference correct step numbers;
(5) BC/VP/taxonomy chain intact.

**Baseline:** Pass 3 (consistency-audit-pass-3.md) declared CONSISTENT against the
(a)–(h) scheme. Pass 4 audits AFTER the F2-Iter5 restructuring merged steps (b)+(c)+(e)
into a single fixpoint as the new step (b), collapsing the eight-step (a)–(h) scheme into
five steps (a)–(e). The canonical source of truth is BC-X.13.002 body in cross-cutting.md.

---

## Count-Guard Script Results

| Script | Exit Code | Result |
|--------|-----------|--------|
| `scripts/check-spec-counts.sh` | 0 | OK |
| `scripts/check-bc-cumulative-counts.sh` | 0 | OK — all 8 surfaces agree at 602 total |
| `scripts/check-bc-no-numeric-test-counts.sh` | 0 | OK |

All three automated guards pass at exit 0. The 602/370/232 split is consistent
across all canonical surfaces (per-file frontmatter, BC-INDEX header, Coverage
Statistics Total row, CANONICAL-COUNTS Sum row and historical note, individual-file
`total_bcs` values, prose grand-total notes).

---

## Documents Reviewed

| Document | Path |
|----------|------|
| BC bodies (canonical) | `.factory/specs/prd/cross-cutting.md` §X.13 (lines 912–1149) |
| BC-INDEX inline summary | `.factory/specs/prd/BC-INDEX.md` lines 689–695 |
| CANONICAL-COUNTS | `.factory/specs/prd/CANONICAL-COUNTS.md` |
| Error taxonomy | `.factory/specs/prd/error-taxonomy.md` §8 (lines 189–204) |
| PRD delta | `.factory/phase-f2-spec-evolution/prd-delta-DEAD-CITATION-CI.md` |
| Architecture delta | `.factory/phase-f2-spec-evolution/arch-delta-DEAD-CITATION-CI.md` |
| Verification delta | `.factory/phase-f2-spec-evolution/verification-delta-DEAD-CITATION-CI.md` |

---

## Canonical Step Scheme (Reference)

The authoritative pipeline per BC-X.13.002 body (cross-cutting.md lines 1005–1018) after
the F2-Iter5 merged-fixpoint restructuring is:

```
(a) Glob skip — contains `*`, `{`, or `}` anywhere → skip entire token
(b) Normalize — single fixpoint (sub-steps 1–6 run until stable):
    (1) strip trailing `::…` symbol-form suffix
    (2) strip trailing `:~[0-9]+` or `:[0-9]+` line-ref suffix
    (3) strip one leading `(` or `[`
    (4) greedily trim trailing `.`, `,`, `;`, `:`
    (5) trim one trailing `)` iff count('(') < count(')')
    (6) trim one trailing `]` iff count('[') < count(']')
(c) Dir-prefix filter — must start with `src/`, `tests/`, `docs/`, `.github/`, `scripts/`
    ALL `.factory/` excluded here
(d) Extension filter — must end with `.md`, `.rs`, `.sh`, `.toml`, `.yml`, `.yaml`
(e) Path::exists() check
```

In the former (a)–(h) scheme (used through Pass 3):
- (a) glob skip, (b) symbol-form strip, (c) line-ref strip, (d) section-ref [no-op],
  (e) trailing/leading punct trim, (f) dir-prefix filter, (g) extension filter, (h) Path::exists()

Step identity changes that create cross-reference drift:
- Old (e) trailing-punct trim → now sub-step (b)(4)
- Old (f) dir-prefix filter → now step (c)
- Old (g) extension filter → now step (d)
- Old (h) Path::exists() → now step (e)

---

## Summary of Findings

| # | Location | Stale Reference | Correct Reference | Severity |
|---|----------|----------------|-------------------|----------|
| P4-1 | cross-cutting.md line 1100 (BC-X.13.003 Behavior) | "BC-X.13.002 step f" (dir-prefix) | step (c) | MINOR |
| P4-2 | cross-cutting.md line 954 (EC-CITE-002) | "BC-X.13.002 step (e)" (trailing-punct) | sub-step (b)(4) | MINOR |
| P4-3 | cross-cutting.md line 956 (EC-CITE-004) | "extension filter at step g" | step (d) | MINOR |
| P4-4 | prd-delta line 49 | "steps (a)–(h) in exact sequence" | pipeline is now (a)–(e) | MINOR |
| P4-5 | arch-delta lines 98, 216 | "step f" for dir-prefix | step (c) | MINOR |
| P4-6 | verification-delta lines 95–96 | "step e" for trailing-punct/leading-punct/]balance branches | sub-steps of step (b) | MINOR |
| P4-7 | verification-delta lines 130, 199, 358 | "step f" or "dir-prefix filter at step f" | step (c) | MINOR |
| P4-8 | cross-cutting.md line 1092 (REVISED note) | "References to former steps (a)–(h) in external docs (arch-delta, verification-delta) must be updated by the architect" — UNFULFILLED DIRECTIVE | Directive not acted on in arch-delta/verification-delta | MINOR |

**MAJOR findings: 0**
**MINOR findings: 8**

---

## Detailed Findings

### P4-1 (MINOR): BC-X.13.003 Behavior references old step (f)

**File:** `cross-cutting.md` line 1100

**Current text:**
```
The guard's dir-prefix filter (BC-X.13.002 step f) recognizes ONLY `src/`, `tests/`,
`docs/`, `.github/`, and `scripts/` as develop-tracked directories.
```

**Issue:** In the new (a)–(e) pipeline, the dir-prefix filter is step **(c)**, not step (f).
Step (f) is undefined in the current scheme; an F4 implementer consulting BC-X.13.003 and
looking up "step f" in BC-X.13.002 will find no such step label.

**Correct reference:** "BC-X.13.002 step (c)"

**Remediation:** Replace "step f" with "step (c)" at cross-cutting.md line 1100.

---

### P4-2 (MINOR): EC-CITE-002 references old step (e) for trailing-punct

**File:** `cross-cutting.md` line 954

**Current text:**
```
trailing comma stripped by trailing-punct rule (BC-X.13.002 step (e)) → both checked independently
```

**Issue:** In the new (a)–(e) pipeline, step (e) is `Path::exists()`. The trailing-punct
trim is sub-step (4) of step **(b)**. The reference "step (e)" now points to the existence
check, not the normalization fixpoint — the opposite of what EC-CITE-002 intends.

**Note:** Pass 3 specifically verified that EC-CITE-002 was corrected from the wrong old
letter to "step (e)". That correction was valid for the (a)–(h) scheme but is now stale
under (a)–(e).

**Correct reference:** "BC-X.13.002 step (b) sub-step (4)"

**Remediation:** Replace "BC-X.13.002 step (e)" with "BC-X.13.002 step (b) sub-step (4)"
at cross-cutting.md line 954.

---

### P4-3 (MINOR): EC-CITE-004 references old step (g) for extension filter

**File:** `cross-cutting.md` line 956

**Current text:**
```
extensionless directory tokens such as `src/cli/issue` are excluded earlier by the
extension filter at step g)
```

**Issue:** In the new (a)–(e) pipeline, the extension filter is step **(d)**, not step (g).

**Correct reference:** "step (d)"

**Remediation:** Replace "step g" with "step (d)" at cross-cutting.md line 956.

---

### P4-4 (MINOR): PRD delta line 49 claims "steps (a)–(h) in exact sequence"

**File:** `prd-delta-DEAD-CITATION-CI.md` line 49

**Current text:**
```
- Canonical pipeline order (SR-004): steps (a)–(h) in exact sequence
```

**Issue:** This bullet is in the "### Normalization Pipeline Improvements" section
describing what Iteration 2 specified for BC-X.13.002. The pipeline was subsequently
restructured to (a)–(e) in F2-Iter5. The prd-delta was not updated to reflect this
restructuring, so it now misrepresents the canonical pipeline to any reader tracing
the spec history.

The prd-delta is a historical record but it is also the primary entry point for
architects and story-writers tracing from DEAD-CITATION-CI to the BC bodies. Claiming
"(a)–(h) in exact sequence" at line 49 directly contradicts BC-X.13.002's cardinality
note at line 1020: "Pipeline is now (a)–(e) instead of (a)–(h)."

**Correct text:** "Canonical pipeline order (SR-004): steps (a)–(e) in exact sequence
(NOTE: F2-Iter5 restructured the former 8-step (a)–(h) pipeline into the current 5-step
(a)–(e) form; see BC-X.13.002 Cardinality note)"

**Remediation:** Update prd-delta line 49 to reflect the current (a)–(e) scheme, or
add a correction footnote immediately after the bullet.

---

### P4-5 (MINOR): arch-delta §2 contains two "step f" references for dir-prefix

**File:** `arch-delta-DEAD-CITATION-CI.md` lines 98 and 216

**Line 98 context:**
```
There is NO `is_off_working_branch_allowlisted` function — `.factory/` exclusion
is handled entirely by the dir-prefix filter inside `extract_path_citations` (step f
above). The filesystem check (`Path::exists()`) is the **only effectful operation**
```

**Line 216 context:**
```
filter inside `extract_path_citations` (step f in the canonical pipeline). Do
not implement or reference an allowlist function.
```

**Issue:** The arch-delta §2 pipeline description was correctly updated to the (a)–(e)
scheme (confirmed: lines 47–71 use (a)–(e) with the merged fixpoint). However, two
subsequent prose references in the Effectful section and §8 Scope Boundary still say
"step f" for the dir-prefix filter. Step (f) does not exist in the current (a)–(e)
scheme; the dir-prefix filter is step (c).

**Note:** The BC-X.13.002 REVISED note at cross-cutting.md line 1092 explicitly directed:
"References to former steps (a)–(h) in external docs (arch-delta, verification-delta)
must be updated by the architect." This directive was partially fulfilled for the pipeline
description block in arch-delta §2 but not for the two prose occurrences at lines 98 and 216.

**Correct reference:** Both occurrences should say "step (c)" (or "step (c) above" / "step (c)
in the canonical pipeline").

**Remediation:** Replace both "step f" occurrences in arch-delta with "step (c)".

---

### P4-6 (MINOR): verification-delta proptest description attributes branches to "step e"

**File:** `verification-delta-DEAD-CITATION-CI.md` lines 95–96

**Current text:**
```
`*`, `{`, `}`, trailing-punct chars (`,`, `.`, `;`, `:`, `)`), and leading-punct
chars `(`, `[`, and `]` so that the glob-skip branch (step a), trailing-punct-trim
branch (step e), leading-punct-strip branch (step e), and `]` balance-trim branch
(step e) are all exercised by random inputs
```

**Issue:** In the new (a)–(e) pipeline:
- "step e" = `Path::exists()` check — it is purely effectful, not a grammar branch
- trailing-punct-trim = sub-step (b)(4)
- leading-punct-strip = sub-step (b)(3)
- `]` balance-trim = sub-step (b)(6)

All three of these branches are sub-steps of step **(b)** (the merged fixpoint), not step (e).
The proptest alphabet description is still functionally correct (the characters listed do
exercise these branches) but the step labels are wrong, which will confuse the F6 hardener
who needs to verify coverage against the canonical pipeline.

**Correct references:**
- "trailing-punct-trim branch (step (b) sub-step (4))"
- "leading-punct-strip branch (step (b) sub-step (3))"
- "`]` balance-trim branch (step (b) sub-step (6))"

**Remediation:** Update verification-delta lines 95–96 to use step (b) sub-step labels.

---

### P4-7 (MINOR): verification-delta has three "step f" references for dir-prefix

**File:** `verification-delta-DEAD-CITATION-CI.md` lines 130, 199, 358

**Line 130 context (proptest note):**
```
excluded by dir-prefix filter at step f). If the proptest engine generates an `s`
```

**Line 199 context (Rust code comment in VP-CITE-002 test template):**
```
    // No is_off_working_branch_allowlisted call — .factory/ is excluded by
    // extract_path_citations dir-prefix filter (step f); no allowlist needed.
```

**Line 358 context (F4 Handoff Checklist):**
```
      handled entirely inside `extract_path_citations` by the dir-prefix filter (step f).
```

**Issue:** All three occurrences reference "step f" for the dir-prefix filter. In the
current (a)–(e) scheme, the dir-prefix filter is step **(c)**. The F4 Handoff Checklist
at line 358 is especially critical: the F4 implementer will write code guided by this
checklist and will look for "step f" in BC-X.13.002 — which no longer exists. This
creates a direct cross-reference breakage at the implementation handoff boundary.

The code comment at line 199 will propagate into the actual test source file written in F4,
creating a CLAUDE.md/source-comment inconsistency with the canonical BC if not corrected
before F4 begins.

**Correct reference:** "step (c)" in all three occurrences.

**Remediation:** Update verification-delta lines 130, 199, and 358: replace "step f" with
"step (c)". The Rust code comment (line 199) especially should be corrected since it will
be copied verbatim into `tests/claude_md_citations.rs`.

---

### P4-8 (MINOR): Unfulfilled architect directive in BC-X.13.002 REVISED note

**File:** `cross-cutting.md` line 1092

**Current text (end of directive):**
```
References to former steps (a)–(h) in external docs (arch-delta, verification-delta)
must be updated by the architect.
```

**Issue:** This directive at the end of the BC-X.13.002 REVISED note was authored as part
of the Iter5 restructuring. It was partially fulfilled:
- arch-delta §2 pipeline block: FULFILLED (now uses (a)–(e))
- arch-delta prose occurrences (lines 98, 216): NOT FULFILLED (still say "step f")
- verification-delta pipeline description and VP-to-BC mapping: FULFILLED (uses (a)–(e))
- verification-delta proptest description (lines 95–96): NOT FULFILLED (still says "step e")
- verification-delta "step f" occurrences (lines 130, 199, 358): NOT FULFILLED

The directive itself is now stale in the sense that the listed "must be updated" work is
partially done. It should be cleared or updated to reflect remaining work (P4-5, P4-6, P4-7
above).

**Note:** The presence of this unfulfilled directive in the canonical BC body is itself an
inconsistency — the BC body should not contain pending action items addressed to the architect;
those belong in the spec-evolution delta docs or a tracking ticket.

**Remediation:** After fixing P4-5/P4-6/P4-7, update or remove the "must be updated by the
architect" sentence from the REVISED note. Replace with: "[UPDATED 2026-06-19 F2-Iter5+P4]
All arch-delta and verification-delta references to former step letters updated."

---

## Verification: Checks That PASS

### 1. BC-X.13.002 canonical pipeline body: CONSISTENT (a)–(e)

cross-cutting.md lines 1005–1018 correctly define the five-step (a)–(e) pipeline with
the merged fixpoint at step (b). The cardinality note at line 1020 explicitly states:
"Pipeline is now (a)–(e) instead of (a)–(h)." The canonical pipeline definition is
authoritative and correct.

### 2. arch-delta §2 pipeline description: CONSISTENT (a)–(e)

arch-delta lines 46–71 use the correct (a)–(e) scheme with merged-fixpoint annotation.
The pipeline description block itself is fully updated. Only the two prose back-references
(P4-5) still carry old step (f) labels.

### 3. BC-INDEX.md inline summary for BC-X.13.002: CONSISTENT

BC-INDEX.md line 694 inline summary reads:
"(a)–(e): (a) glob/brace-glob skip; (b) unified normalize fixpoint [...]; (c) dir-prefix
filter; (d) extension filter; (e) Path::exists() check"
This is correct and matches the canonical pipeline.

### 4. Count integrity: 602/370/232 across all surfaces

All three count guard scripts exit 0. The 602 total, 370 individually-bodied, and 232
range-collapsed values are consistent across CANONICAL-COUNTS.md Sum row, BC-INDEX.md
Coverage Statistics Total row, cross-cutting.md `total_bcs: 145` / `definitional_count: 79`,
and the per-file frontmatter sum. No count drift from the structural edit.

### 5. CI-CITE-001 failure message: SINGLE-SOURCE-OF-TRUTH

The four-line canonical failure message is byte-identical across all five surfaces:

```
CLAUDE.md cites file paths that do not exist on disk:
  <path> (line N)
Fix the citation or restore the file.
Note: .factory/, glob, and symbol-form tokens are auto-excluded.
```

| Surface | Status |
|---------|--------|
| `error-taxonomy.md` §CI-CITE-001 Message format | PASS — authoritative |
| `cross-cutting.md` BC-X.13.001 Postconditions (failure code block) | PASS — verbatim |
| `arch-delta-DEAD-CITATION-CI.md` §2 Effectful section code block | PASS — verbatim |
| `verification-delta-DEAD-CITATION-CI.md` VP-CITE-002 Rust string literal | PASS — verbatim with `\n` escapes |
| `prd-delta-DEAD-CITATION-CI.md` §Canonical Failure Message code block | PASS — verbatim |

No variant wording. No "add to allowlist" sentence anywhere.

### 6. EC-CITE-026/027/028 step references: CONSISTENT with (a)–(e)

The three new edge cases introduced in F2-Iter5 all reference the correct step labels:

- **EC-CITE-026** (cross-cutting.md line 1056): traces `(src/config.rs:~42)` through sub-step
  (3)/(5) to strip parens, then sub-step (2) to strip `:~42`. References "sub-steps (1)/(2)"
  and "sub-step (3)/(5)" — all within step (b). Correct.

- **EC-CITE-027** (cross-cutting.md line 1057): traces `src/api/client.rs:195,` through
  sub-step (4) then sub-step (2). References "sub-step (4)" and "sub-step (2)". Correct.

- **EC-CITE-028** (cross-cutting.md line 1058): traces `src/foo.rs::bar().` through sub-step
  (1). References "sub-step (1)". Correct.

All three new EC vectors correctly reference step (b) sub-steps, not old top-level letters.

### 7. verification-delta VP-to-BC Mapping Summary (line 310): CONSISTENT

The summary table at verification-delta line 310 correctly uses "step a: glob-skip; step b:
merged fixpoint [...]; step c: dir-prefix filter [...]; step d: extension filter; step e:
Path::exists()". Fully consistent with (a)–(e) canonical scheme.

### 8. F6 Handoff Checklist multi-pass vectors (verification-delta lines 384–387): CONSISTENT

The F6 checklist correctly notes: "the former 'step (e)' references in checklists now
correspond to step (b) sub-steps (3)–(6) in the (a)–(e) pipeline." This self-correcting
note acknowledges the transition. However the F4 Handoff Checklist (P4-7 above) does
not carry the equivalent correction.

### 9. BC/VP/taxonomy chain: INTACT

| Chain | Status |
|-------|--------|
| BC-X.13.001 → VP-CITE-001, VP-CITE-002 | VALID — both VPs in verification-delta |
| BC-X.13.002 → VP-CITE-001 | VALID |
| BC-X.13.003 → VP-CITE-002 | VALID |
| CI-CITE-001 → BC-X.13.001, BC-X.13.002, BC-X.13.003 | VALID — all three exist |
| arch-delta `traces_to` → prd-delta + F1 delta analysis | VALID — both files exist |
| verification-delta `related_bcs` → BC-X.13.001..003 | VALID |
| VP-CITE-001/002 → BC body §Verification Properties | VALID |
| No VP-INDEX / verification-architecture.md referenced | VALID — project convention |

### 10. Re-scope: no surviving positive allowlist language

Every occurrence of "allowlist", "off-branch", "is_off_working_branch_allowlisted",
"research is checked" appears only in SUPERSEDED or PROHIBITION context. BC-X.13.003
and arch-delta §2 and §8 all clearly state "NO `is_off_working_branch_allowlisted`
function". The dir-prefix exclusion is the sole mechanism per BC-X.13.002 step (c).

### 11. BC-INDEX.md X.13 inline summary: CONSISTENT

BC-INDEX.md lines 693–695 describe BC-X.13.001/002/003 correctly with (a)–(e) pipeline
notation and correct dir-prefix at step (c), extension at step (d), Path::exists() at step (e).

---

## Severity Classification

All 8 findings are classified **MINOR**, not MAJOR, for the following reasons:

1. **No blocking behavioral inconsistency:** The canonical definition of the pipeline
   (BC-X.13.002 body) is correct. The stale step-letter cross-references are annotation
   drift, not definitional drift.

2. **F4 implementer risk:** The stale references DO pose an F4 implementation risk:
   - A code comment in verification-delta (P4-7, line 199) will be transcribed verbatim
     into `tests/claude_md_citations.rs`. The comment says "step f" which is a ghost step.
   - The F4 Handoff Checklist (P4-7, line 358) says "step f" — an implementer following
     the checklist will look for step f in BC-X.13.002 and find nothing.
   These are pre-implementation risks, not implementation errors. They are MINOR because
   the canonical BC body (the authoritative source) is correct and will take precedence.

3. **No count surface impact:** All 8 findings are prose/annotation stale references.
   Zero impact on 602/370/232 count surfaces or count guard scripts.

4. **Failure message is correct:** The single most critical correctness invariant
   (CI-CITE-001 canonical message verbatim in test code) is correct across all 5 surfaces.

---

## Pass/Fail by Audit Area

| Area | Result |
|------|--------|
| Step-scheme consistency: BC body | PASS — (a)–(e) correctly defined |
| Step-scheme consistency: BC-INDEX.md inline summary | PASS — (a)–(e) correctly summarized |
| Step-scheme consistency: arch-delta pipeline block | PASS — (a)–(e) correctly described |
| Step-scheme consistency: arch-delta prose cross-refs | FAIL — 2 stale "step f" (P4-5) |
| Step-scheme consistency: verification-delta VP mapping | PASS — (a)–(e) correctly referenced |
| Step-scheme consistency: verification-delta proptest | FAIL — 3 stale "step e" (P4-6) |
| Step-scheme consistency: verification-delta checklist | FAIL — 3 stale "step f" (P4-7) |
| Step-scheme consistency: BC-X.13.003 Behavior | FAIL — 1 stale "step f" (P4-1) |
| Step-scheme consistency: EC-CITE-002 | FAIL — 1 stale "step (e)" (P4-2) |
| Step-scheme consistency: EC-CITE-004 | FAIL — 1 stale "step g" (P4-3) |
| Step-scheme consistency: prd-delta history bullets | FAIL — 1 stale "(a)–(h)" (P4-4) |
| Count integrity: 602/370/232 all surfaces | PASS — 3 guards at exit 0 |
| Failure message single-source-of-truth | PASS — 5/5 surfaces byte-identical |
| EC-CITE-026/027/028 step references | PASS — all use step (b) sub-steps correctly |
| BC/VP/taxonomy chain | PASS — all IDs resolve |
| Re-scope: no allowlist language | PASS — no positive allowlist endorsement |

---

## Verdict

**INCONSISTENT — 8 MINOR findings, 0 MAJOR findings.**

The canonical (a)–(e) pipeline definition in BC-X.13.002 body is correct and authoritative.
The F2-Iter5 restructuring was successfully applied to the canonical BC text, the BC-INDEX
inline summary, and the arch-delta pipeline description block. However, the restructuring
was NOT propagated to:

1. Six step-letter cross-references in cross-cutting.md (BC-X.13.003, EC-CITE-002, EC-CITE-004)
2. Five step-letter prose references in arch-delta (lines 98, 216)
3. Six step-letter references in verification-delta (lines 95–96, 130, 199, 358)
4. One historical bullet in prd-delta (line 49)

The most critical pre-F4 fix is P4-7 (verification-delta line 199 code comment): the Rust
test template will be copied verbatim into `tests/claude_md_citations.rs` and should not
contain a reference to the nonexistent "step f".

**Blocking for F3 story creation:** No. These are annotation fixes, not spec changes.
**Blocking for F4 implementation start:** P4-7 (verification-delta line 199) should be
fixed before F4 begins; the other findings can be addressed in the same editorial pass.

### Recommended Remediation (all in one pass)

| File | Line(s) | Change |
|------|---------|--------|
| `cross-cutting.md` | 954 | `step (e)` → `step (b) sub-step (4)` |
| `cross-cutting.md` | 956 | `step g` → `step (d)` |
| `cross-cutting.md` | 1100 | `step f` → `step (c)` |
| `cross-cutting.md` | 1092 | Clear "must be updated by architect" directive (fulfilled) |
| `prd-delta-DEAD-CITATION-CI.md` | 49 | `(a)–(h)` → `(a)–(e)` + parenthetical noting Iter5 restructuring |
| `arch-delta-DEAD-CITATION-CI.md` | 98 | `step f above` → `step (c) above` |
| `arch-delta-DEAD-CITATION-CI.md` | 216 | `step f in the canonical pipeline` → `step (c) in the canonical pipeline` |
| `verification-delta-DEAD-CITATION-CI.md` | 95–96 | `step e` (×3) → `step (b) sub-step (4)`, `step (b) sub-step (3)`, `step (b) sub-step (6)` |
| `verification-delta-DEAD-CITATION-CI.md` | 130 | `step f` → `step (c)` |
| `verification-delta-DEAD-CITATION-CI.md` | 199 | `(step f)` → `(step (c))` |
| `verification-delta-DEAD-CITATION-CI.md` | 358 | `(step f)` → `(step (c))` |
