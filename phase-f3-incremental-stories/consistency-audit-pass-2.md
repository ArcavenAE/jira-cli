---
document_type: consistency-report
scope: S-MAINT-DEAD-CITATION-CI
audited_artifact: .factory/stories/S-MAINT-DEAD-CITATION-CI.md
auditor: consistency-validator
date: 2026-06-19
pass: 2
verdict: CONSISTENT (1 MAJOR finding, 1 MINOR finding, 0 blocking)
---

# Consistency Audit — S-MAINT-DEAD-CITATION-CI — Pass 2

**Story:** `.factory/stories/S-MAINT-DEAD-CITATION-CI.md`
**Auditor:** consistency-validator
**Date:** 2026-06-19
**Pass:** 2 (post signature change `Vec<String>` → `Vec<(String, usize)>`; story revised to 12 ACs)
**Verdict:** CONSISTENT — 1 MAJOR finding (stale snippet in verification-delta), 1 MINOR finding (stale heading+description in arch-delta). Zero blocking findings. Gate: PASS.

---

## Count-Guard Exit Codes

| Script | Exit Code | Status |
|--------|-----------|--------|
| `scripts/check-spec-counts.sh` | 0 | PASS |
| `scripts/check-bc-cumulative-counts.sh` | 0 | PASS (602 total BCs) |
| `scripts/check-bc-no-numeric-test-counts.sh` | 0 | PASS |

All three count guards pass clean.

---

## Summary Table

| Check | Result | Notes |
|-------|--------|-------|
| 1. Signature consistency — `Vec<(String, usize)>` across all surfaces | PASS with 1 MAJOR | All authoritative surfaces (story, cross-cutting.md, verification-delta, error-taxonomy.md) show new signature. One code snippet in verification-delta uses old API form. arch-delta section heading still says `Vec<String>` (MINOR). |
| 2. Message consistency — real line numbers, no literal "(line N)" in test output | PASS | All surfaces correctly distinguish the `{n}` runtime integer from the spec placeholder. No surface prescribes emitting a literal "(line N)". |
| 3. AC count — frontmatter 12 vs body count | PASS | `acceptance_criteria_count: 12`; 12 `### AC-` headings in body; 12 rows in AC traceability table. Exact match. |
| 4. AC→BC→VP traceability (all 12 ACs) | PASS | All 12 ACs trace to real BCs (BC-X.13.001/002/003) and valid VPs (VP-CITE-001/002). No phantom references. |
| 5. Holdout count — total_holdouts 60; body prose 60; 3 H-CITE-* present | PASS | OBS-001 from Pass 1 is FIXED. Body prose now reads "60 holdout scenarios." Header count: 60 `### H-` headings confirmed. H-CITE-001/002/003 present in Group 8. |
| 6. Frontmatter `bcs:`/`behavioral_contracts:` ↔ body BC table ↔ ACs | PASS | Both frontmatter arrays list [BC-X.13.001, BC-X.13.002, BC-X.13.003]. Body BC table has all three. Every AC traces to one of these three BCs. Bidirectionally consistent. |
| 7. No broken cross-references | PASS | All EC-CITE-NNN, file paths, BC IDs, VP IDs, and doc references resolve correctly. |
| 8. Count guards | PASS | See row above. |

---

## Detailed Findings

### Finding F2-AUDIT-001 (MAJOR) — `test_docs_path_is_in_scope` snippet in verification-delta uses old `Vec<String>` API

**File:** `.factory/phase-f2-spec-evolution/verification-delta-DEAD-CITATION-CI.md`, line 346
**Surface:** VP-CITE-002 §Dir-prefix exclusion verification, `test_docs_path_is_in_scope` code snippet

**Old text:**
```rust
assert!(citations.contains(&"docs/adr/0016-windows-build-target.md".to_string()));
```

**Problem:** `citations` is `Vec<(String, usize)>` after the signature change. The `.contains(&String)` call is the API for `Vec<String>`. This snippet will NOT compile against the updated return type. An implementer following this code example verbatim will get a type error.

**Authoritative surfaces (correct):**
- `cross-cutting.md` BC-X.13.002 postcondition (line 1045): `Returns Vec<(String, usize)>`
- `cross-cutting.md` canonical test vectors note (line 1085): "tests assert on the path component of each tuple"
- `verification-delta` VP-CITE-001 proptest (lines 121–131): `for (path, _line) in &result { ... }` — correctly destructures
- `verification-delta` VP-CITE-002 integration test (lines 253–260): `let dead: Vec<(String, usize)> = ...` — correct
- `verification-delta` VP-CITE-002 fixture test (lines 304): `dead.iter().any(|(p, _)| p == "src/DOES_NOT_EXIST_IN_ANY_JR_BUILD.rs")` — correct
- Story AC-001: `Vec<(String, usize)>` — correct

**Correct replacement for the stale snippet:**
```rust
fn test_docs_path_is_in_scope() {
    let doc = "See `docs/adr/0016-windows-build-target.md` for details.";
    let citations = extract_path_citations(doc);
    // citations: Vec<(String, usize)> — compare the path component
    assert!(citations.iter().any(|(p, _)| p == "docs/adr/0016-windows-build-target.md"));
}
```

**Severity:** MAJOR — this will cause a compile error if copied verbatim. However, it is in the transient F2/F3 working artifact (verification-delta) which the verification-delta itself notes is "intentionally a transient F2/F3 working artifact consumed by the test-writer in F4. They are NOT the permanent spec record." The authoritative guidance for test writers is the VP-CITE-001/002 strategy sections (which are correct) and the story ACs (which are correct). The stale snippet appears only in the `test_docs_path_is_in_scope` example buried after the three canonical `.factory/` exclusion test snippets. The gate is PASS because the authoritative implementation spec surfaces (story ACs, BC postconditions, VP proptest code) all show the correct tuple API, and a careful implementer will notice the type mismatch. But the F4 implementer should be warned to correct this snippet.

**Remediation:** Update the `test_docs_path_is_in_scope` snippet in `verification-delta-DEAD-CITATION-CI.md` line 346 to use `.iter().any(|(p, _)| ...)` form. Low urgency — the verification-delta is a transient reference document and the test file will be authored fresh from scratch under TDD. Recommend fixing in the same commit as `tests/claude_md_citations.rs` to keep the record clean.

---

### Finding F2-AUDIT-002 (MINOR) — arch-delta section heading and description retain old `Vec<String>` text

**File:** `.factory/phase-f2-spec-evolution/arch-delta-DEAD-CITATION-CI.md`, lines 33–37

**Old text:**
```
### Pure: `extract_path_citations(doc: &str) -> Vec<String>`

This function is **deterministic and side-effect-free**: it takes a string
(the CLAUDE.md text, already loaded at compile time via `include_str!`) and
returns a sorted, deduplicated `Vec<String>` of candidate file paths after
```

**Problem:** The section heading shows `-> Vec<String>` and the body says "returns a sorted, deduplicated `Vec<String>`." The signature was changed to `Vec<(String, usize)>` in prd-delta Iteration 3 (F3-feedback amendment). The prd-delta lists `arch-delta-DEAD-CITATION-CI.md` in its "Files amended in this iteration" section only as entries in `cross-cutting.md`, `error-taxonomy.md`, `verification-delta`, and `stories/S-MAINT-DEAD-CITATION-CI.md` — arch-delta was NOT in the amended list. The arch-delta was therefore not updated for Iter 3.

**Authoritative surfaces (correct):**
- `prd-delta-DEAD-CITATION-CI.md` Iter 3: "Signature change (BC-X.13.002): `extract_path_citations(doc: &str) -> Vec<(String, usize)>`"
- `cross-cutting.md` BC-X.13.002 Behavior (line 1005): `Vec<(String, usize)>`
- `arch-delta` §7 Architecture Documents Status: all architecture docs "UNCHANGED" — this disclaimer predates Iter 3 and the arch-delta itself is a "no architecture change" document; the stale section heading is in the purity-boundary description, not in `src/` architecture

**Mitigating context:** The arch-delta is a "no structural architecture change" document whose primary content is the purity boundary description. The purity argument (function is pure, no I/O) is entirely unchanged by the signature change — a `Vec<(String, usize)>` is equally pure as a `Vec<String>`. The stale heading is misleading but does not affect purity reasoning or any downstream implementation decision. It will NOT cause a compile error (unlike F2-AUDIT-001).

**Also stale in arch-delta:** Line 106, the integration-test canonical failure message example block still shows:
```
  <path> (line N)
```
where `(line N)` was the pre-Iter-3 placeholder form. The Iter-3 update changed this to `(line {n})` in cross-cutting.md and error-taxonomy.md. The arch-delta's example still uses the old notation. This is consistent with MINOR severity — it is illustrative prose in a transient spec artifact, and the authoritative form is in cross-cutting.md and error-taxonomy.md.

**Severity:** MINOR — the arch-delta is a transient F2 artifact; the authoritative signature is in BC-X.13.002 (cross-cutting.md). The stale heading is misleading but the implementer reads cross-cutting.md and the story (both correct) as primary sources. Does not block implementation.

**Remediation:** Update arch-delta-DEAD-CITATION-CI.md:
- Line 33: `### Pure: extract_path_citations(doc: &str) -> Vec<(String, usize)>`
- Line 37: "returns `Vec<(String, usize)>` entries (each a `(normalized_path, 1-based-line-number)` pair) of candidate file paths after"
- Line 106 example: replace `(line N)` with `(line 142)` to match the canonical example in cross-cutting.md lines 938-939.
Low urgency — can be done in the same PR as `tests/claude_md_citations.rs` as a documentation cleanup commit.

---

### Confirmation: OBS-001 from Pass 1 is FIXED

**Pass 1 finding:** `holdout-scenarios.md` body prose read "57 holdout scenarios" (stale after H-CITE-001/002/003 added to reach 60).

**Current state:** Line 20 of `holdout-scenarios.md` now reads "60 holdout scenarios for Phase 4 evaluation." Confirmed fixed. The `### H-` heading count is 60 (verified). `total_holdouts: 60` in frontmatter. All three surfaces (frontmatter, body prose, heading count) are consistent. OBS-001 is CLOSED.

---

## Signature/Message Consistency Check — Authoritative Surfaces

The following table summarizes every surface that states the `extract_path_citations` return type and/or the CI-CITE-001 message format, with the current state of each:

| Surface | Signature | Message format | Old form present? |
|---------|-----------|---------------|-------------------|
| `cross-cutting.md` BC-X.13.002 Behavior (line 1005) | `Vec<(String, usize)>` | `(line {n})` / example `(line 142)` | NO |
| `cross-cutting.md` BC-X.13.001 postconditions (lines 938-943) | N/A | `(line 142)` / `(line 287)` in example block; `(line {n})` in prose | NO |
| `cross-cutting.md` BC-X.13.002 Canonical Test Vectors note (line 1085) | tuple note | N/A | NO |
| `cross-cutting.md` BC-X.13.002 Source (line 1121) | `Vec<(String, usize)>` | N/A | NO |
| `cross-cutting.md` BC-X.13.003 Source (line 1182) | `Vec<(String, usize)>` | N/A | NO |
| `error-taxonomy.md` CI-CITE-001 (lines 200-201) | `Vec<(String, usize)>` | `(line {n})` + example `(line 142)` | NO |
| `verification-delta` VP-CITE-001 description | `Vec<(String, usize)>` | N/A | NO |
| `verification-delta` VP-CITE-001 proptest code | tuple destructure `(path, _line)` | N/A | NO |
| `verification-delta` VP-CITE-002 integration test code | `Vec<(String, usize)>` | `format!("{} (line {})", p, n)` | NO |
| `verification-delta` VP-CITE-002 fixture test code | tuple destructure `|(p, _)|` | N/A | NO |
| `verification-delta` VP-CITE-002 mapping table (line 366) | `Vec<(String, usize)>` | `src/foo.rs (line 142)` | NO |
| `verification-delta` `test_docs_path_is_in_scope` snippet (line 346) | (implicit `Vec<String>` via `.contains(&String)`) | N/A | **YES — MAJOR (F2-AUDIT-001)** |
| `arch-delta` §2 section heading + description (lines 33, 37) | `Vec<String>` | `(line N)` in example (line 106) | **YES — MINOR (F2-AUDIT-002)** |
| Story AC-001 body | `Vec<(String, usize)>` | N/A | NO |
| Story AC-002 code block | `Vec<(String, usize)>` comment + filter | N/A | NO |
| Story AC-003 body | `(line {n})` prose + `format!("{} (line {})", p, n)` | real integer, not literal `(line N)` | NO |
| Story AC-003 explicit clarification (lines 184-185) | N/A | "literal text `(line N)` MUST NOT appear in actual test output" | NO (correctly prohibits old form) |
| Story AC-004 code block | tuple destructure | N/A | NO |
| Story AC-010 body | tuple API throughout | `format!("{} (line {})", p, n)` | NO |
| Story AC traceability table | `Vec<(String, usize)>` in AC-001 row | N/A | NO |
| Story T-1 stub | `Vec<(String, usize)>` | N/A | NO |
| `prd-delta` Iter 3 amendment | `Vec<(String, usize)>` | real integer | NO |

**Summary:** 2 surfaces still show old form; both are in transient F2 working artifacts (arch-delta, verification-delta). All authoritative spec surfaces (cross-cutting.md, error-taxonomy.md) and all story ACs show the new form. No literal `(line N)` placeholder appears in any implementation prescription for what the running test emits.

---

## AC to BC to VP Traceability — All 12 ACs

| AC | BC(s) | VP | BC exists in cross-cutting.md? | VP exists in verification-delta? |
|----|-------|-----|-------------------------------|----------------------------------|
| AC-001 | BC-X.13.002 | VP-CITE-001 | YES (line 1001) | YES |
| AC-002 | BC-X.13.001 | VP-CITE-002 | YES (line 919) | YES |
| AC-003 | BC-X.13.001 | VP-CITE-002 | YES | YES |
| AC-004 | BC-X.13.001 | VP-CITE-002 | YES | YES |
| AC-005 | BC-X.13.003 | VP-CITE-001 | YES (line 1127) | YES |
| AC-006 | BC-X.13.002 | VP-CITE-001 | YES | YES |
| AC-007 | BC-X.13.002 | VP-CITE-001 | YES | YES |
| AC-008 | BC-X.13.002 | VP-CITE-001 | YES | YES |
| AC-009 | BC-X.13.001 | VP-CITE-002 | YES | YES |
| AC-010 | BC-X.13.001 | VP-CITE-002 | YES | YES |
| AC-011 | BC-X.13.002 | VP-CITE-001 | YES | YES |
| AC-012 | BC-X.13.002, BC-X.13.001 | VP-CITE-001 | YES (both) | YES |

All 12 ACs trace to real, authored BCs. Both VPs resolve. The frontmatter `acceptance_criteria_count: 12` matches the 12 `### AC-` headings and the 12 rows in the traceability table. No phantom BCs or VPs. No orphaned ACs.

---

## Holdout Check — Pass 2

| Surface | Count | Match |
|---------|-------|-------|
| `holdout-scenarios.md` frontmatter `total_holdouts:` | 60 | YES |
| `holdout-scenarios.md` body prose (line 20) | 60 | YES (OBS-001 fixed) |
| `grep -c "^### H-"` actual heading count | 60 | YES |
| Story `holdout_anchors:` | [H-CITE-001, H-CITE-002, H-CITE-003] | Present in Group 8 |
| `check-spec-counts.sh` | exit 0 | PASS |

All holdout count surfaces agree. OBS-001 is closed.

---

## Cross-Reference Integrity

| Reference | Resolution | Status |
|-----------|-----------|--------|
| `.factory/specs/prd/cross-cutting.md §BC-X.13` | File exists; §BC-X.13 at line 912 | OK |
| `.factory/phase-f2-spec-evolution/arch-delta-DEAD-CITATION-CI.md` | File exists | OK |
| `.factory/phase-f2-spec-evolution/prd-delta-DEAD-CITATION-CI.md` | File exists | OK |
| `.factory/phase-f2-spec-evolution/verification-delta-DEAD-CITATION-CI.md` | File exists | OK |
| `tests/claude_md_citations.rs` (files_created — not yet on disk) | Pre-implementation; absence expected | OK |
| `tests/ci_gate_completeness.rs` (style reference) | File exists | OK |
| `src/partial_match.rs` (style reference) | File exists per CLAUDE.md | OK |
| EC-CITE-002/003/016/017/022–034 | All anchored to BC-X.13.001/002 edge cases | OK |
| `error-taxonomy.md §8` (CI-CITE-001) | §8 exists; CI-CITE-001 entry at line 191 | OK |
| VP-CITE-001, VP-CITE-002 | Both in verification-delta | OK |

---

## Verdict

**CONSISTENT. Gate: PASS.**

The two stale surfaces (arch-delta heading and one verification-delta code snippet) are in transient F2 working artifacts. Neither blocks F4 implementation because:

1. The F4 implementer's primary sources — story ACs, BC-X.13.002 in cross-cutting.md, and the VP-CITE-001/002 proptest/integration-test strategy sections in verification-delta — all show the correct `Vec<(String, usize)>` API and the `format!("{} (line {})", p, n)` format string.
2. AC-003 explicitly prohibits the literal `(line N)` from appearing in test output ("The literal text `(line N)` MUST NOT appear in actual test output").
3. The `test_docs_path_is_in_scope` stale snippet (F2-AUDIT-001) uses an assertion that will fail to compile, making the error immediately visible to the implementer rather than producing a silent wrong result.

### Action items before F4 handoff (non-blocking)

1. **MAJOR (F2-AUDIT-001, recommended before F4):** Update `test_docs_path_is_in_scope` snippet in `verification-delta-DEAD-CITATION-CI.md` line 346 to use `.iter().any(|(p, _)| p == "docs/adr/0016-windows-build-target.md")` form.

2. **MINOR (F2-AUDIT-002, can defer to PR cleanup):** Update `arch-delta-DEAD-CITATION-CI.md` lines 33/37/106: section heading `-> Vec<String>` → `-> Vec<(String, usize)>`; body description "returns a sorted, deduplicated `Vec<String>`" → "returns `Vec<(String, usize)>` entries"; example block `(line N)` → `(line 142)`.

Neither action item blocks the F4 implementer from writing correct, compiling code. The story spec is implementation-ready.
