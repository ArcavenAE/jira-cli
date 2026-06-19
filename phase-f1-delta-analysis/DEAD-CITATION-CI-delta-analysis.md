# Delta Analysis: DEAD-CITATION-CI

**Bundle:** DEAD-CITATION-CI  
**Date:** 2026-06-19  
**Analyst:** Architect (vsdd-factory)  
**Origin:** MAINT-PG-DEAD-CITATION-CI (2026-06-19 maintenance sweep)  
**Status:** Draft — Awaiting Human Approval

---

## 1. Classification

**Intent:** `feature` (new guard that did not previously exist)  
**Feature type:** `infrastructure` (CI quality gate, no product behavior change)  
**Quick-dev eligible:** No. While the implementation is a single new test file, the scope
requires full BCs and VPs because:
- This is a quality-gate guard that must never false-positive (correctness contract)
- The parser grammar requires careful unit tests for edge cases
- The allowlist exclusion design must be documented as a behavioral contract

**Scope:** Standard (not trivial). Multi-scope rationale: the guard requires a
hand-rolled parser with grammar edge-case coverage, an explicit allowlist, and
a CLAUDE.md doc-fallout note. The false-positive surface is the make-or-break design
risk and must be contracted via BCs.

**Quick-dev assessment:** ALL of the quick-dev criteria hold EXCEPT "no new BCs needed"
— this guard introduces behavioral contracts around what the parser must/must-not flag.
Per skill definition, if any criterion fails the full pipeline applies. Recommend full F2-F7
as the human requested.

---

## 2. Background and Motivation

The 2026-06-19 maintenance sweep (commit `6bdb251`) found and manually removed 4 dead
`.factory/research/issue-361-*.md` `Detail:` citations from CLAUDE.md (DRIFT-D13). The
removals were correct — those research files were never committed to the working branch.
The root cause was a process gap: no automated check existed to catch dead file-path
citations in CLAUDE.md at CI time.

The maintenance sweep also found a missing ADR-0014 file (D9) which was subsequently
created. The CI guard being designed here would have caught the file-path citation of
`ADR-0014` in the CLAUDE.md Key Decisions section against the non-existent
`docs/adr/0014-jsm-request-type-dispatch.md` at PR time.

As of `develop` HEAD (post-sweep), CLAUDE.md contains **zero dead citations**. The guard
will be a green test from the moment it is written.

---

## 3. Current Citation State (Ground Truth as of develop HEAD)

### 3a. Citation forms present in CLAUDE.md today

Exhaustive enumeration of citation-prefix forms found by inspection:

| Form | Example | Count in CLAUDE.md | Notes |
|------|---------|-------------------|-------|
| `Detail: \`path\`` | `Detail: \`.factory/research/S-3.03-wave3-verification.md\`` | 6 structured | Backtick-quoted path after `Detail:` label |
| `Spec: \`path\`` | `Spec: \`docs/specs/adf-block-html.md\`` | 3 structured | Backtick-quoted path after `Spec:` label |
| `Runbook: \`path\` §N` | `Runbook: \`docs/specs/e2e-live-jira-testing.md\` §9` | 1 structured | Has section-ref suffix |
| Inline backtick path in prose | `\`docs/adr/0016-windows-build-target.md\`` | ~30 | Paths embedded in running text |
| `See: \`path\`` | — | 0 | Form appears in CLAUDE.md citation-convention note but not used as an actual citation yet |

**Forms NOT present (confirm as out-of-scope for initial pass):**
- `Source:` prefix — appears only in `.factory/specs/prd/bc-*.md` files, not in CLAUDE.md
- `Trace:` prefix — same, BC files only
- `See:` prefix — documented but unused in CLAUDE.md currently
- Bare (non-backtick) `Detail: path` — all `Detail:` uses are backtick-quoted

### 3b. Live citations confirmed (develop HEAD)

All `.factory/research/` citations in current CLAUDE.md resolve:
- `.factory/research/S-3.03-wave3-verification.md` — EXISTS
- `.factory/research/S-3.03-v2-design-verification.md` — EXISTS
- `.factory/research/issue-331-issuetype-bulk-schema.md` — EXISTS
- `.factory/research/issue-473-bare-url-autolink-scope.md` — EXISTS (inline prose, not after Detail:)

All `docs/specs/`, `docs/superpowers/`, `docs/adr/`, `tests/`, `src/`, `scripts/` backtick
citations resolve to real files. Zero dead citations on current `develop`.

### 3c. The one legitimate DEAD pattern (excluded by design)

`\`.factory/specs/prd/bc-*.md\`` appears in CLAUDE.md line 329 — this is a **glob pattern**
(contains `*`), not a real path. It must be excluded from the guard. No other glob patterns
with path separators appear.

---

## 4. Impact Boundary

### Files NEW

| File | Change Type | Justification |
|------|-------------|---------------|
| `tests/claude_md_citations.rs` | NEW | The citation guard itself — integration test following `*_release_gate.rs` idiom |

### Files MODIFIED

| File | Change Type | What Changes |
|------|-------------|--------------|
| `CLAUDE.md` | MODIFIED | Add doc-fallout note in "AI Agent Notes" section documenting the new guard test, following the pattern established for `*_release_gate.rs` guards |

### Files NOT CHANGED (regression baseline)

- All `src/` files — no production code changes whatsoever
- `.github/workflows/ci.yml` — no workflow changes needed; `tests/claude_md_citations.rs`
  is auto-picked up by `cargo test --all-features` (ci.yml line 57), which is already in
  `ci-gate.needs` (ci.yml line 328). **Confirmed: no ci-gate.needs edit required.**
- All other `tests/*.rs` files — no modifications
- All `docs/` files — no changes except the doc-fallout note in CLAUDE.md
- All `scripts/` files — no new bash scripts

### Why no CI-yaml change is needed

The existing `test` job runs `cargo test --all-features` on a 3-OS matrix
(ubuntu-latest, macos-latest, windows-latest; ci.yml lines 48, 57). A new
`tests/claude_md_citations.rs` file is automatically compiled into the test binary
and collected by that command. The `ci-gate` job has `needs: [fmt, clippy, test, ...]`
(ci.yml line 328) — so the guard rides `ci-gate` for free, consistent with the
documented project convention (CLAUDE.md "CI Gate" section).

---

## 5. Citation Grammar: In-Scope vs Out-of-Scope

### 5a. IN-SCOPE citation forms (guard must check these)

The guard checks any backtick-quoted token inside CLAUDE.md that:
1. Contains `/` (path separator)
2. Has a known directory prefix: `src/`, `tests/`, `docs/`, `.factory/`, `.github/`, `scripts/`
3. Has a file extension (`.md`, `.rs`, `.sh`, `.toml`, `.yml`, `.yaml`)

These tokens appear in two contexts:
- After a citation prefix (`Detail:`, `Spec:`, `Runbook:`) — structured form
- Embedded in running prose — backtick-quoted form

The guard handles both contexts identically: tokenize backtick contents, filter by
directory prefix and extension, clean suffixes, check `Path::exists()`.

### 5b. OUT-OF-SCOPE (guard must NOT check these — false-positive risk)

| Pattern | Example | Exclusion Rule |
|---------|---------|----------------|
| Glob patterns | `` `.factory/specs/prd/bc-*.md` `` | Skip any token containing `*` |
| Symbol-form citations | `` `src/adf.rs::push_text` `` or `` `adf::tests::test_bare_*` `` | Strip `::fn` suffix before path check; result `src/adf.rs` is then checked as normal |
| Line-ref citations | `` `src/config.rs:~NN` `` | Strip `:~NN` and `:NN` suffixes before path check |
| Section refs | `docs/specs/e2e-live-jira-testing.md §9` | Strip ` §N` suffix before path check |
| External URLs | `` `http://127.0.0.1:53682/callback` `` | No known directory prefix; naturally excluded by filter (1)+(2) above |
| ADR shorthand | `ADR-0014` (without path) | No `/` present; naturally excluded by filter (1) |
| BC references | `BC-3.2.013` | No `/` present; naturally excluded |
| Issue numbers | `issue #361` | No `/` and no extension; naturally excluded |
| JRACLOUD IDs | `JRACLOUD-95368` | No `/`; naturally excluded |
| Struct/type names | `` `std::sync::Mutex` `` | Has `::` but no known dir prefix; excluded by filter (2) |
| Test function names | `` `test_bare_url_split_by_emphasis_links_only_leading_run` `` | No `/`; naturally excluded |
| JSON field names | `` `"issuetype"` `` | No `/`; naturally excluded |
| Environment variable names | `` `JR_BASE_URL` `` | No `/`; naturally excluded |
| `.factory/specs/prd/bc-*.md` and similar factory-branch paths | Any `.factory/specs/prd/` path | These live on `factory-artifacts` branch, NOT in the working tree. **Explicit allowlist required.** |
| `.factory/research/` paths | Already handled — all current ones exist. For future safety, add `.factory/research/` to the off-working-branch allowlist if any path is intentionally absent | Allowlist |

### 5c. The off-working-branch allowlist

Per the research recommendation, paths that intentionally live on non-working branches
must be allowlisted (not checked). The canonical set for this repo:

- `.factory/specs/prd/` — factory spec artifacts, on `factory-artifacts` branch
- `.factory/holdout-scenarios/` — holdout docs, same branch
- `.factory/cycles/` — cycle artifacts (if ever cited), same branch

Note: `.factory/research/` files ARE committed to the working branch (`develop`) — they
are present in the working tree. They are NOT off-branch. Current `.factory/research/`
citations all resolve. Future dead `.factory/research/` citations SHOULD fail the guard.

**Decision: do NOT add `.factory/research/` to the allowlist.** Its files live on
the working branch and should be checked. Only `.factory/specs/` and
`.factory/holdout-scenarios/` and `.factory/cycles/` need allowlisting.

---

## 6. False-Positive Risk Analysis

This is the make-or-break design risk. Exhaustive enumeration:

### Risk 1: Symbol-form citations (`path::fn`)
**Example:** `` `src/api/jsm/servicedesks.rs::require_service_desk` ``  
**Risk:** Guard treats the whole string including `::fn` as the path → `Path::exists()` returns
false because no file has that literal name.  
**Mitigation:** Strip everything from `::` onward before the existence check. The base
`src/api/jsm/servicedesks.rs` then resolves correctly.  
**Residual risk:** None. Stripping `::` is unambiguous — `::` cannot appear in a file path
on any supported OS (Windows, macOS, Linux).

### Risk 2: Approximate line refs (`path:~NN` or `path:NN`)
**Example:** `` `src/adf.rs:~42` ``  
**Risk:** Guard attempts to check `src/adf.rs:~42` which does not exist.  
**Mitigation:** Strip `:~[0-9]+` and `:[0-9]+` suffixes before existence check.  
**Note:** CLAUDE.md citation convention says "never a bare `file:NN-MM`" but existing
references may use `:~NN`. The guard must handle both.

### Risk 3: Section refs (`path §N`)
**Example:** `docs/specs/e2e-live-jira-testing.md §9`  
**Risk:** If the guard tokenizes on whitespace and includes `§9` in the path token.  
**Mitigation:** Tokenize on whitespace; the `§9` becomes a separate non-path token and
is naturally excluded by the directory-prefix filter.

### Risk 4: Glob patterns (`bc-*.md`)
**Example:** `` `.factory/specs/prd/bc-*.md` ``  
**Risk:** `Path::exists()` on a glob pattern returns false.  
**Mitigation:** Explicit exclusion: skip any token containing `*` before the existence
check. Only one such pattern exists in current CLAUDE.md.

### Risk 5: Factory-branch paths (most important false-positive vector)
**Example:** `.factory/specs/prd/bc-6.1.md` (hypothetical future citation)  
**Risk:** These paths exist on `factory-artifacts` branch but NOT in a standard working-tree
checkout. A guard without an allowlist would false-positive on every CI run.  
**Mitigation:** Explicit allowlist of off-working-branch path prefixes:
  - `.factory/specs/` (except `.factory/specs/prd/bc-*.md` which is already a glob)
  - Actually: only if someone adds a non-research `.factory/specs/` path to CLAUDE.md.
  Currently CLAUDE.md only cites `.factory/research/` paths under `.factory/`.
**Decision for initial pass:** Allowlist `.factory/specs/`, `.factory/holdout-scenarios/`,
`.factory/cycles/`. `.factory/research/` is NOT allowlisted (files exist on working branch).

### Risk 6: `Detail: ADR-0006` mixed with file path on same line
**Example:** `Detail: ADR-0006, \`docs/superpowers/specs/2026-04-30-embedded-oauth-app-design.md\``  
**Risk:** The guard might try to check `ADR-0006` as a path.  
**Mitigation:** `ADR-0006` has no `/` and no known directory prefix — excluded by the
path-filter naturally. Only the backtick-quoted `docs/...` path is checked.

### Risk 7: Inline `http://` or `https://` URLs in backticks
**Example:** `` `http://127.0.0.1:53682/callback` ``  
**Risk:** This contains `/` characters and could be mistaken for a path.  
**Mitigation:** URL tokens start with `http://` or `https://` — they do not start with
known directory prefixes (`src/`, `docs/`, etc.). The directory-prefix filter excludes them.

### Risk 8: Path-like backtick content in code examples
**Example:** `` `~/.config/jr/config.toml` `` or `` `%APPDATA%\jr` ``  
**Risk:** These look like paths but are not relative paths from the repo root.  
**Mitigation:** None of these start with known directory prefixes (`src/`, `docs/`, etc.).
The `~` prefix and `%` prefix are not in the allowlist — naturally excluded.

### Risk 9: `tests/spec-count-fixtures/` nested path
**Example:** If CLAUDE.md ever cited `tests/spec-count-fixtures/run-tests.sh`  
**Risk:** Nested `tests/` subdirectory path — should work fine since `Path::exists()` handles
nested paths correctly.  
**No current instance in CLAUDE.md — risk is LOW.**

### Summary: False-positive risk level

| Risk | Level | Handled by |
|------|-------|-----------|
| Symbol-form `::fn` | MEDIUM (common in CLAUDE.md) | Strip `::.*` suffix |
| Approximate line refs `:~NN` | LOW (present but few) | Strip `:~?[0-9]+` suffix |
| Glob patterns `*` | LOW (one instance: `bc-*.md`) | Skip if contains `*` |
| Factory-branch paths | HIGH (would break CI constantly) | Explicit off-branch allowlist |
| External URLs in backticks | LOW (URLs, not paths) | Directory-prefix filter |
| Prose paths like `~/.config/jr` | LOW | Directory-prefix filter |
| `Detail: ADR-NNN` mixed with file | LOW | No `/` in ADR ref |

**Overall false-positive risk with mitigations applied: LOW.**

---

## 7. New BCs and VPs Recommended

### New Behavioral Contracts (BCs)

Recommend 3 BCs for the `tests/claude_md_citations.rs` guard:

| BC ID | Contract | Notes |
|-------|----------|-------|
| BC-CITE-001 | Every backtick-quoted token in CLAUDE.md that (a) starts with a known directory prefix (`src/`, `tests/`, `docs/`, `.factory/`, `.github/`, `scripts/`) and (b) has a file extension, resolves to a real on-disk file relative to the repo root. Symbol suffixes (`::fn`), line-ref suffixes (`:~NN`), and section refs (` §N`) are stripped before the check. | Core correctness contract |
| BC-CITE-002 | Tokens containing `*` (glob patterns) are excluded from the path-existence check. The literal `.factory/specs/prd/bc-*.md` in CLAUDE.md must not cause the guard to fail. | Glob exclusion |
| BC-CITE-003 | Paths under off-working-branch prefixes (`.factory/specs/`, `.factory/holdout-scenarios/`, `.factory/cycles/`) are excluded from the check. These prefixes are documented in a comment in `tests/claude_md_citations.rs`. `.factory/research/` paths are NOT excluded — they live on the working branch. | Cross-branch exclusion |

The BC numbering (BC-CITE-NNN) is provisional; the product-owner will assign final BC-S.SS.NNN
identifiers in F2 spec crystallization. Expect these to land in a new subsystem (SS-XX)
under the Infrastructure/CI category.

### New Verification Properties (VPs)

Recommend 2 VPs:

| VP ID | Property | Verification Method |
|-------|----------|---------------------|
| VP-CITE-001 | `extract_path_citations(doc)` correctly identifies path tokens from representative CLAUDE.md excerpts and rejects non-path tokens (symbols, URLs, BCs, ADR shorthands, globs) | Rust inline `#[cfg(test)]` unit tests — proptest over grammar variants |
| VP-CITE-002 | `test_claude_md_citations_resolve_to_real_files()` passes on the current codebase with all current CLAUDE.md citations and fails deterministically when a dead path is inserted | Integration test (self-verifying: always green on develop; red if citation rots) |

**Total BCs recommended: 3**  
**Total VPs recommended: 2**

---

## 8. Regression Risk

| Module / File | Change Type | Risk | Reason |
|--------------|-------------|------|--------|
| `tests/claude_md_citations.rs` | NEW | LOW | New test file; no existing code to break |
| `CLAUDE.md` | MODIFIED (doc-fallout note only) | LOW | Additive text change; no existing test anchors on the insertion point |
| All `src/` | UNCHANGED | NONE | Zero production code changes |
| `ci.yml` | UNCHANGED | NONE | Guard auto-picked up by existing test job |

Regression risk: **LOW overall.** The only behavioral change is the addition of a new
always-run test. If the test is written correctly (green from day 1 on develop), it
introduces no regression vectors.

**Existing tests in the regression risk zone:** None — no existing test files are modified.

---

## 9. Story Note

Story `S-MAINT-DEAD-CITATION-CI` will be formally created in Phase F3 (story decomposition).
Based on scope, it is a single-story feature:

**Story summary:** Implement `tests/claude_md_citations.rs` citation guard  
**Acceptance criteria (preview):**
- AC-001: Parser correctly extracts path tokens (BC-CITE-001)
- AC-002: Glob patterns are skipped (BC-CITE-002)
- AC-003: Off-working-branch paths are allowlisted with comments (BC-CITE-003)
- AC-004: Guard passes green on current develop HEAD
- AC-005: CLAUDE.md doc-fallout note added in "AI Agent Notes" section documenting the guard

---

## 10. Scope Decision

The human has explicitly requested full F2-F7. This analysis confirms that full F2-F7 is
appropriate and beneficial:

- F2 (Spec crystallization): Formalize 3 BCs and 2 VPs with proper BC-S.SS.NNN IDs
- F3 (Story decomposition): Single story `S-MAINT-DEAD-CITATION-CI`
- F4 (TDD implementation): Red gate (5 ACs) → `tests/claude_md_citations.rs` + CLAUDE.md note
- F5 (Adversarial review): Review parser edge cases, false-positive surface, allowlist completeness
- F6 (Formal hardening): proptest on `extract_path_citations` grammar; mutation testing on parser
- F7 (Convergence): Verify guard passes green on develop; PATCH release

**Honest assessment for the record:** The change is small enough that quick-dev could
have been justified if not for the false-positive surface complexity — the parser edge
cases and allowlist require contracted BCs to prevent future regressions to the guard
itself. Full pipeline is correct.

---

## 11. Impact Assessment Table

| Artifact | Impact | Details |
|----------|--------|---------|
| PRD / BCs | NEW | 3 new BCs (BC-CITE-001/002/003), new subsystem |
| Architecture | NONE | No module changes, no new modules in `src/` |
| UX | NONE | Infrastructure/CI only |
| Stories | NEW | 1 new story (S-MAINT-DEAD-CITATION-CI) |
| Tests | NEW | `tests/claude_md_citations.rs` |
| Verification | NEW | 2 new VPs |
| CI / Workflow | NONE | No `.github/workflows/ci.yml` edits required |
| CLAUDE.md | MODIFIED | Doc-fallout note only |

---

## 12. Files Summary

### New files (2)
```
tests/claude_md_citations.rs           NEW — citation guard test
```

### Modified files (1)
```
CLAUDE.md                              MODIFIED — doc-fallout note in "AI Agent Notes"
```

### Regression baseline (unchanged)
All `src/` files, all other `tests/*.rs` files, `.github/workflows/ci.yml`,
all `docs/` files, all `scripts/` files.

---

## Sign-off checklist

- [x] All affected components identified with change type
- [x] Regression risk assessed per affected module
- [x] Existing tests in the risk zone enumerated (none)
- [x] Files NOT changed explicitly listed as regression baseline
- [x] Feature type classified: `infrastructure`
- [x] Intent classified: `feature`
- [x] Trivial scope assessed: standard (not trivial) — parser grammar requires BCs
- [x] False-positive surface fully enumerated (9 risk categories, all mitigated)
- [x] Citation grammar decision: in-scope forms documented, out-of-scope exclusion rules specified
- [x] BC and VP counts: 3 BCs, 2 VPs
- [x] Single-repo (no affected-repos.txt needed)
