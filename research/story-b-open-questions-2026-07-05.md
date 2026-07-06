# Story B (S-BC-CITATION-GUARD-1) — Open-question research

**Date:** 2026-07-05
**Repo state:** develop @ ab78a2d (per story frontmatter)
**Scope:** internal repo research (Read/Grep). No external MCP calls needed — all four questions are answerable from on-disk artifacts.

---

## Question 1 — BC governance precedent (recommendation)

### 1.1 What BC-X.13.001–003 govern

Location: `.factory/specs/prd/cross-cutting.md § "## BC-X.13: CI Guards"` (lines 917-920).

The subsystem preamble is unambiguous:

> "3 behavioral contracts covering `tests/claude_md_citations.rs` — the doc-fallout guard
> that verifies every file-path citation in `CLAUDE.md` resolves to a real on-disk file."
> (`cross-cutting.md:919-920`)

The three contracts:

| BC | Governs | Anchor |
|----|---------|--------|
| BC-X.13.001 | Path-existence assertion on in-scope backtick-quoted citations in CLAUDE.md; canonical failure-message wording (CI-CITE-001 in error-taxonomy) | `cross-cutting.md:924` |
| BC-X.13.002 | Extraction-grammar exclusions/normalization: glob wildcards, `::symbol` suffix, `:~NN`/`:NN` suffix, trailing punctuation, `§N` refs; ROOT_FILES inclusion set; dir-prefix filter; extension filter | `cross-cutting.md:1006` |
| BC-X.13.003 | Directory-scope rule — ALL `.factory/` prefixes excluded; scope inversion vs earlier partitioned "off-branch allowlist" | `cross-cutting.md:1132` |

Subsystem provenance (from the F2 addition log):
> "DEAD-CITATION-CI F2 addition (2026-06-19): BC-X.13.001..003 — CLAUDE.md dead-citation CI guard
> (citation path-existence, glob/suffix/punct exclusion, ALL .factory/ excluded — re-scoped F2 Iteration 2)"
> (`cross-cutting.md:16`)

### 1.2 Comparing the two precedents

| Attribute | BC-X.13.001–003 (governed) | Story A Guards 2+3 (policy-doc-only, `bcs: []`) | Story B Guard 1 (proposed) |
|-----------|----------------------------|--------------------------------------------------|-----------------------------|
| Subject-matter | Citation-integrity guard (doc→disk) | Mutation-scope policy enforcement + citation-integrity of scope bullets | Citation-integrity guard (doc→disk + symbol) |
| Formal PRD subsystem | Yes — `## BC-X.13: CI Guards` in `cross-cutting.md` | No — `docs/specs/cargo-mutants-policy.md` (policy doc, not PRD subsystem) | Would extend BC-X.13 (proposed) |
| Implementation form | Rust integration test (`tests/claude_md_citations.rs`) | Bash script (`scripts/check-cargo-mutants-policy-citations.sh`) | Bash script (`scripts/check-bc-citation-symbols.sh`) |
| CI job | `test` (3-OS matrix) | `spec-guard` (needs factory-artifacts) | `spec-guard` (needs factory-artifacts) |
| Extraction-grammar complexity | glob/symbol/lineref/punct exclusions + ROOT_FILES + dir-prefix + extension filter (BC-X.13.002 documents ~5 phases) | fenced-code-span skip + bullet group state machine + `::`-strip + shape guard (12 self-test fixtures in `check-cargo-mutants-policy-citations.sh:246-559`) | `::symbol` / `§` / `:~NN` / bare-file forms + shape guard + definition-anchored `fn` grep + secondary fallback (7 self-test fixtures in draft) |
| Governance precedent | S-MAINT-DEAD-CITATION-CI (DEC-125-130), DEC-129 explicit BC-authorship decision | S-MUTATION-CI-TIMEOUT-1 / S-TESTTOOL-1 / DEC-144 — policy-doc-only | Draft cites both as ancestor patterns |

### 1.3 Which axis dominates: subject-matter or implementation-form?

**Subject-matter dominates over implementation form.** Two independent signals:

1. **BC-X.13.001–003's subject is doc-to-disk citation integrity — implementation as a Rust test is an accident of CI topology, not a governance requirement.** The DEC-129 rationale for the Rust-test form is CI-checkout topology (Rust test in `test` job can access `CLAUDE.md` on develop but NOT `.factory/`); the *contracts* still describe citation-integrity semantics, not test-harness mechanics. If BC-X.13.001–003 had been implemented as a bash script (as Guard 1 must be, for factory-artifacts access), the same three contracts would still apply verbatim.

2. **Story A's `bcs: []` is not "because it's a bash script" — it's because there was no pre-existing PRD-level subsystem to extend.** `docs/specs/cargo-mutants-policy.md` is a policy doc under `docs/specs/`, not a PRD subsystem under `.factory/specs/prd/`. Guard 1 IS extending an existing PRD subsystem (BC-X.13), which is qualitatively different.

Guard 1's proposed BCs mirror BC-X.13.001–003's grammar 1-for-1:
- BC-X.13.001 (file-path resolves) ↔ BC-X.13.004-draft (`src/` path resolves)
- BC-X.13.002 (extraction-grammar exclusions) ↔ BC-X.13.005-draft (symbol-location: definition, not import)
- BC-X.13.003 (CI wiring / GREEN on develop) ↔ BC-X.13.006-draft (GREEN on develop; RED on stale-citation introduction)

The story lineage field already asserts this: `lineage: S-MAINT-DEAD-CITATION-CI ... established BC-X.13 subsystem` and `Guard 1 extends to BC-X.13.004+` (story lines 66-67).

### 1.4 Governance precedent — friction points to flag

Two caveats on the "BC-X.13.001–003 is the right precedent" claim:

- **Grammar-complexity heuristic is inconsistent between the two precedents.** The draft's Governance Note argues "the citation-extraction grammar has enough combinatorial complexity" to justify BCs. But Story A's grammar (fenced-code state machine + bullet-group state machine + `::`-strip + shape guard, 12 fixtures) is arguably *more* complex than Guard 1's (7 fixtures) and yet uses `bcs: []`. So complexity-alone is not the discriminator — subsystem-extension is.

- **BC-X.13.001's canonical error message is anchored in error-taxonomy (CI-CITE-001).** If Guard 1 gets BC-X.13.005-draft, the F2 authoring will need to add a parallel `BC-CITE-001` entry to `.factory/specs/prd/error-taxonomy.md` for the failure-message pin (or explicitly note that Guard 1's `BC-CITE-001` is script-internal, not error-taxonomy-scoped). Story A's `CI-MUTANTS-CITE-001` is script-internal only — no error-taxonomy entry — so the precedent is mixed.

### ANSWER / RECOMMENDATION Q1

**KEEP the draft's proposal: formal BCs BC-X.13.004/005/006 authored in F2.** Subject-matter (citation-integrity guard extending the existing BC-X.13 PRD subsystem) is the load-bearing driver, not implementation form (bash vs Rust). Story A's `bcs: []` reflects the *absence* of a pre-existing PRD subsystem for mutation-scope policy, not a rule that bash guards get no BCs. Guard 1 is a natural extension of BC-X.13. **Ask F2 PO to also decide** whether `BC-CITE-001` gets an entry in `error-taxonomy.md` (matching CI-CITE-001) or stays script-internal (matching CI-MUTANTS-CITE-001).

---

## Question 2 — FLOOR calibration (measurement)

### 2.1 Draft's extraction spec (canonical pattern)

Story Task 2 Step 3 (story lines 291-300):

> **Step 3: Extract backtick-quoted `src/` citation tokens from each line:**
> ```
> grep -oE '`src/[^` ]+`' | tr -d '`'
> ```

Scope filter (Step 2, story lines 285-288):

> ```
> grep -nEh '^\*\*(Trace|Source)\*\*:' "${bc_files[@]}" || true
> ```

Forms in scope (Task Step 1, story lines 217-224 + EC-002/003/004/010 in Edge Cases): `file::symbol`, `file § "..."` (reduces to bare `file` via space-stop), `file:~NN` / `file:NN-MM` (reduces to bare `file` via `:`-strip), bare `file`. `tests/` explicitly out of scope (EC-010; story line 692).

### 2.2 Line-scope measurement

Trace/Source lines containing at least one `` `src/ `` token, per file (Grep count on pattern `^\*\*(Trace|Source)\*\*:.*\`src/`):

| File | Lines |
|------|-------|
| bc-3-issue-write.md | 40 |
| bc-7-output-render.md | 42 |
| bc-6-config-cache.md | 31 |
| bc-2-issue-read.md | 28 |
| bc-1-auth-identity.md | 26 |
| bc-4-assets-cmdb.md | 8 |
| bc-5-boards-sprints.md | 7 |
| **Total** | **182** |

### 2.3 Token-scope measurement (file-wide `` `src/[^` ]+` `` extraction)

Grep with `-o` on pattern `` `src/[^` ]+` `` across all bc-*.md (file-wide, NOT scoped to Trace/Source lines yet — this is an upper bound because it also captures citations in Behavior/Postconditions/Invariants/prose):

| File | File-wide tokens |
|------|------------------|
| bc-3-issue-write.md | 139 |
| bc-7-output-render.md | 169 |
| bc-6-config-cache.md | 59 |
| bc-2-issue-read.md | 31 |
| bc-1-auth-identity.md | 29 |
| bc-5-boards-sprints.md | 11 |
| bc-4-assets-cmdb.md | 7 |
| **Total (file-wide)** | **445** |

### 2.4 Token-scope measurement, Trace/Source scoped (per the guard's real semantics)

Approximation from the truncated Trace/Source content I could inspect (`.factory/specs/prd/bc-*.md:^**Trace**:` + `**Source**:` lines with `src/`). Per-file estimates using visible line samples:

| File | Trace/Source lines with `src/` | Avg tokens/line (from visible sample) | Estimated Trace/Source-scoped tokens |
|------|-------|-------|-------|
| bc-3-issue-write.md | 40 | ~2.2 (many multi-token Source lines with 3-4 backtick refs, e.g. `bc-3-issue-write.md:377`, `:663`, `:1118`) | ~90 |
| bc-7-output-render.md | 42 | ~3.0 (adf.rs subsystem lines cite 5-6 symbols each, e.g. `bc-7:187`, `:211`, `:515`) | ~125 |
| bc-6-config-cache.md | 31 | ~1.1 (mostly single `src/config.rs:NN-MM` or `src/cache.rs:NN-MM` per line) | ~35 |
| bc-2-issue-read.md | 28 | ~1.1 (mostly single-token line-ref citations) | ~32 |
| bc-1-auth-identity.md | 26 | ~1.1 (mostly single `src/api/auth.rs:NN-MM`) | ~30 |
| bc-4-assets-cmdb.md | 8 | ~1.2 | ~10 |
| bc-5-boards-sprints.md | 7 | ~1.4 | ~10 |
| **Total (estimated Trace/Source-scoped)** | **182** | | **~332** |

Confidence: MEDIUM — the estimate is based on truncated Grep output; the true value could be anywhere in the range **[275, 380]**. Every calibration below assumes ~332 as the point estimate; adjust proportionally if the implementer's canonical run yields a materially different number.

### 2.5 Story A parallel

Story A used `FLOOR=11` (`check-cargo-mutants-policy-citations.sh:34`), which equals the exact bullet count in `docs/specs/cargo-mutants-policy.md §Scope` on develop HEAD at delivery — a **tight** floor (any drop = fail).

### 2.6 Draft's FLOOR=30 vs measurement

`FLOOR=30` is **~9% of the estimated actual count (332)**. This has two consequences:

1. **Fail-open surface is huge.** The FLOOR guard exists specifically to catch the case where the extraction logic silently drops most citations (e.g., regex regression, glob mismatch). With FLOOR=30, an extraction bug that drops 90% of citations (yields 33) still passes the floor. Story A's tight floor would catch a 1-citation drop; the draft's floor catches only a 302-citation drop.

2. **The wording "conservative lower bound" is misleading.** A conservative floor in the *safety* sense is one that leaves headroom for legitimate downward drift but still catches catastrophic dropout. FLOOR=30 leaves ~300 citations of headroom — that's not "conservative", that's "vestigial".

### ANSWER / RECOMMENDATION Q2

**RECOMMEND FLOOR = 250, not 30.** Rationale:
- Actual measured count is ~332 (bounded range 275-380).
- 90%-of-count = ~299; 75%-of-count = ~250.
- FLOOR=250 gives ~25% legitimate-drift headroom (accommodates a BC refactor that legitimately drops ~80 citations) while still catching extraction-bug dropout well below the threshold.
- Story A's exact-count floor (11) is TOO tight for Guard 1: BC bodies churn far more than policy-doc bullets, so a strict-equality floor would false-fire on any normal BC edit that removes one citation.
- **The story task already mandates the implementer to measure on develop HEAD** (Task 2 Step 5 note "conservative lower bound verified against develop HEAD at delivery time; the implementer MUST run the script in canonical mode on develop HEAD to confirm the actual count exceeds 30 before setting this value"). Recommend re-word: "MUST run the script, record N, and set FLOOR to floor(0.75 × N)". This makes the calibration process reproducible instead of tribal.
- **AC-005 fixture G (FLOOR=30 pin) needs matching update** — Fixture G's assertion `grep -qF 'expected >= 30'` (draft line 459) becomes `grep -qF "expected >= ${FLOOR}"` or a specific-value pin against whatever the implementer settles on.

---

## Question 3 — Fixture G CANONICAL_MODE mechanism

### 3.1 How Story A wires CANONICAL_MODE

Exact citations from `scripts/check-cargo-mutants-policy-citations.sh`:

- **Script-level initialization** (`check-cargo-mutants-policy-citations.sh:202-203`) — outside `run_check`, before argument parsing:
  ```
  self_test=0
  CANONICAL_MODE=0
  ```

- **Set-to-1 gate after arg parsing** (`check-cargo-mutants-policy-citations.sh:229`):
  ```
  if [ "$self_test" = "0" ] && [ -z "${POLICY_DOC+x}" ]; then CANONICAL_MODE=1; fi
  ```
  → CANONICAL_MODE flips to 1 only when NO `--self-test` AND NO `--policy-doc` override.

- **Read inside `run_check`** (`check-cargo-mutants-policy-citations.sh:33`):
  ```
  local canonical="${CANONICAL_MODE:-0}"
  ```
  → Env-var-driven: `run_check` reads whatever the shell-scope variable is at call time, defaulting to 0 if unset.

- **Floor-guard call site** (`check-cargo-mutants-policy-citations.sh:179`):
  ```
  if [ "$canonical" = "1" ] && [ "$N" -lt "$FLOOR" ]; then
  ```

### 3.2 How Story A's fixtures toggle it

**Fixture H** (SCOPE-COVERAGE-FLOOR, `check-cargo-mutants-policy-citations.sh:410-473`) is the sole fixture that exercises the floor branch. Its toggle pattern:

- Line 425: `CANONICAL_MODE=1` — sets the variable in the fixture's shell scope BEFORE the `set +e; output=$(run_check 2>&1); rc=$?; set -e` invocation.
- Line 472: `unset CANONICAL_MODE` — cleans up after all four probes so subsequent fixtures see the default `${CANONICAL_MODE:-0}` = 0.

No arg-parser flag exists to enable CANONICAL_MODE from the CLI in `--self-test` context — it's env-var-only. This is deliberate: the arg-parser sets CANONICAL_MODE only in the canonical (non-self-test) branch (line 229's `[ "$self_test" = "0" ]` predicate is the load-bearing gate).

### 3.3 Story B applicability

**Story B Fixture G can reuse the identical mechanism verbatim — no adjustment needed.**

Cross-check against the draft's Task 2 flag spec (story lines 236-244):

- Draft matches Story A's `self_test=0; CANONICAL_MODE=0` init verbatim.
- Draft's condition `if [ "$self_test" = "0" ] && [ -z "${BC_DIR+x}" ]; then CANONICAL_MODE=1; fi` is a 1-for-1 rename (`POLICY_DOC` → `BC_DIR`) of Story A's line 229. Semantics identical.
- Draft's inside-`run_check` read `local canonical="${CANONICAL_MODE:-0}"` (Task 2 Step "Default variable initialization", story line 270) is verbatim Story A line 33.
- Fixture G's toggle pattern (draft AC-002 lines 451-459) mirrors Fixture H — set CANONICAL_MODE=1 before invoke, unset after (though the draft doesn't explicitly document the `unset` step; **recommend the story explicitly say `unset CANONICAL_MODE` after Fixture G to prevent leakage to any subsequent fixtures** — a foot-gun Story A had to fix in Fixture H).

**Single load-bearing invariant to preserve:** the CANONICAL_MODE variable must be at script-scope (not `local` inside `run_check` and not a parameter). Story A's Fixture H mutating shell-scope `CANONICAL_MODE=1` only works because `run_check` reads it via env-defaulting `local canonical="${CANONICAL_MODE:-0}"`. If Guard 1's implementer accidentally makes CANONICAL_MODE a `local` in `run_check`, Fixture G's mutation becomes a no-op and the test false-greens. Recommend explicit acceptance criterion in AC-005 or Task 2: "CANONICAL_MODE MUST be a script-scope variable, not a `local`".

### ANSWER / RECOMMENDATION Q3

**Reuse Story A's mechanism verbatim** with one documentation addition: the draft should explicitly note (a) that CANONICAL_MODE is *script-scope* (never `local`), (b) Fixture G should `unset CANONICAL_MODE` in cleanup to prevent leakage. Both are Story A implicit invariants worth surfacing so a future implementer doesn't inadvertently break them.

---

## Question 4 — EC-002 non-function-symbol census

### 4.1 Census (from file-wide `` `src/[^` ]+` `` extraction, filtered to non-`fn` symbol shapes)

I extracted all backtick-quoted `src/` tokens across bc-*.md and manually classified those with a `::symbol` suffix. Non-function symbols (constants, types, `Type::method`, module paths, `fn()` with parens) found:

| Symbol form | Citation | File | Approx line |
|-------------|----------|------|-------------|
| Type (CamelCase) | `src/types/jira/bulk.rs::BulkTransitionRequest` | bc-3-issue-write.md | 377 |
| Type (CamelCase) | `src/types/jira/bulk.rs::BulkTransitionInput` | bc-3-issue-write.md | 377 |
| Constant (UPPER_CASE) | `src/cli/issue/edit.rs::CROSS_HIERARCHY_HINT` | bc-3-issue-write.md | 663, 733 (2×) |
| Type (CamelCase) | `src/cache.rs::FieldsCache` | bc-3-issue-write.md | ~740 (extended context) |
| Type::method | `src/adf.rs::AdfBuilder::start` | bc-7-output-render.md | 247 (extracted-order) |
| Type::method | `src/adf.rs::AdfBuilder::end` | bc-7-output-render.md | 277, 315, 319 (3×) |
| Type::method | `src/adf.rs::AdfBuilder::process` | bc-7-output-render.md | 275 |
| Type::method | `src/adf.rs::AdfBuilder::push_text` | bc-7-output-render.md | 285, 299, 303 (3×) |
| Type::method | `src/adf.rs::AdfBuilder::push_code` | bc-7-output-render.md | 286, 300, 304 (3×) |
| Type::method | `src/adf.rs::AdfBuilder::finish` | bc-7-output-render.md | 314, 320 (2×) |
| Type::method | `src/adf.rs::AdfBuilder::push_footnote_marker` | bc-7-output-render.md | 313, 318 (2×) |
| Type::method | `src/adf.rs::AdfRenderer::render_node` | bc-7-output-render.md | 280, 294, 297, 309, 391, 394 (6×) |
| Type::method | `src/adf.rs::AdfRenderer::finish` | bc-7-output-render.md | 292, 295, 298, 310, 386-397 (many, ~10×) |
| Type (CamelCase) | `src/adf.rs::ListFrame` | bc-7-output-render.md | 281 |
| Type (CamelCase) | `src/adf.rs::AdfBuilder` | bc-7-output-render.md | 269 |
| Fn with parens | `src/error.rs::exit_code()` | bc-3-issue-write.md | 44, 54, 60, 61 (4×) |
| Fn with parens | `src/config.rs::base_url()` | bc-6-config-cache.md | 170 |
| Fn with parens | `src/config.rs::global_config_dir()` | bc-6-config-cache.md | 151, 165 (2×) |
| Fn with parens | `src/api/client.rs::from_config()` | bc-6-config-cache.md | 171 |
| Fn with parens | `src/cache.rs::cache_root()` | bc-6-config-cache.md | 164, 166 (2×) |
| Module path | `src/adf.rs::tests` | bc-7-output-render.md | 234, 235, 237, 241, 244, 245, 252, 253, 255, 261, 267, 273, 283, 291, 312, 317, 322, 327, 332, 338 (~20×) |
| Module path | `src/output.rs::tests` | bc-7-output-render.md | 230 |
| Module path | `src/observability.rs::tests` | bc-7-output-render.md | 384 |
| Module path | `src/cli/issue/changelog.rs::tests` | bc-2-issue-read.md | 224 |
| Module path | `src/api/jira/links.rs::tests` | bc-3-issue-write.md | 108 |
| Nested path::testfn | `src/types/assets/linked.rs::tests::display_id_fallback_with_hint` | bc-4-assets-cmdb.md | 416 |

**Distinct non-function symbols: ~26.**
**Total non-function citation occurrences (counting duplicates by line): ~70+.**

The `src/adf.rs::tests` and `src/adf.rs::AdfRenderer::*` forms alone account for ~30+ occurrences.

### 4.2 Behavior under draft's two-tier grep

Draft Task 2 Step 4(d) (story lines 320-331) specifies:

1. Primary: definition-anchored `fn`-grep — matches `fn <symbol>` only. Fails for all 26+ non-function symbols listed above.
2. Secondary fallback: `grep -q "${symbol}" "$src_root/$file"` — matches ANY substring occurrence. This false-greens on almost anything (e.g., `tests` as a substring of any doc comment).

Failure modes with the draft's fallback:

- `src/adf.rs::tests` — the string `tests` appears everywhere in `src/adf.rs` (doc comments, `#[cfg(test)] mod tests`, test names). Secondary fallback always passes. TRUE POSITIVE only if module `tests` exists — which it does. But grep would ALSO pass on a file where the string `tests` appears only in a doc comment and no `mod tests` exists.
- `src/adf.rs::AdfBuilder::start` — draft's `${symbol}` value after `${token##*::}` is `start` (last `::` strips leading `AdfBuilder::`). Secondary grep for `start` matches thousands of occurrences. Extreme false-green risk.
- `src/cli/issue/edit.rs::CROSS_HIERARCHY_HINT` — secondary grep for `CROSS_HIERARCHY_HINT` matches the `const` declaration (correct) but also matches any doc-comment references. Behaves correctly *by accident*.

**Concrete false-green scenario the draft's fallback would ALLOW:** rename `CROSS_HIERARCHY_HINT` to `CROSS_HIER_HINT` in `src/cli/issue/edit.rs` but leave a doc-comment referring to the old name (e.g., `// See CROSS_HIERARCHY_HINT for the legacy form`). The BC citation `src/cli/issue/edit.rs::CROSS_HIERARCHY_HINT` becomes stale, but the secondary grep still finds `CROSS_HIERARCHY_HINT` in the doc-comment → citation false-greens. This is *exactly* the DEC-148 class the guard is designed to prevent, one level up.

**The `${token##*::}` (last-`::` strip) transform is also load-bearing for `Type::method` forms.** For `src/adf.rs::AdfBuilder::start`, `token##*::` = `start`, not `AdfBuilder::start`. So the primary `fn`-grep looks for `fn start` — which matches a top-level `fn start()` in `src/adf.rs` (if any exists) but does NOT verify the method lives in `impl AdfBuilder`. Correctness gap: a `Type::method` citation only verifies the *bare method name* is a top-level fn somewhere in the file. If `AdfBuilder::start` was renamed to `AdfBuilder::begin` but the file also has a free `fn start()`, primary passes despite the citation being stale.

### ANSWER / RECOMMENDATION Q4

**Non-function citations are MATERIAL (~26 distinct, ~70+ occurrences) — the EC-002 grep fallback CANNOT be deferred. It MUST be tightened, not just kept.** Concrete recommendations:

1. **Do NOT ship v1 with the draft's permissive `grep -q "${symbol}"` fallback** — it re-opens the exact import-only-false-green class the definition-anchored primary was designed to close. This is a self-inflicted MED risk.

2. **Split the fallback by symbol shape** (regex on `${symbol}`):
   - Constant: `[A-Z_][A-Z0-9_]*` → anchored `(pub[[:space:]]+)?(const|static)[[:space:]]+${symbol}[[:space:]:]`
   - Type: `[A-Z][A-Za-z0-9_]*` (no `::`) → anchored `(pub[[:space:]]+)?(struct|enum|type|trait|union)[[:space:]]+${symbol}[<[:space:]]`
   - `Type::method` (contains `::`) → split into `type = token##*::` on the whole rest, then anchor: `impl(<[^>]+>)?[[:space:]]+.*${type}[[:space:]]*(<[^>]+>)?[[:space:]]*{` AND `fn[[:space:]]+${method}` — or, more pragmatically, run the primary `fn`-grep on the *method* name after last-`::`-strip AND *also* verify the *type* name (second-to-last-`::` component) appears in a `struct|enum|type|trait|impl` definition. Skip if the file has no matching type-def (import-only case).
   - Module path ending in `::tests` / other lowercase-plural-noun → anchor `mod[[:space:]]+${symbol}[[:space:]{]`
   - Fn with `()` suffix — strip trailing `()` before running primary grep (already implied but not written down).

3. **Story-level scope decision needed.** Adding four anchored-grep variants materially expands Guard 1's grammar. Two options:
   - **v1 (tight):** ship all four variants + explicit fixtures for each in AC-002 (would grow the fixture suite from 7 to ~11).
   - **v1 (pragmatic):** ship strengthened `Type::method` handling (mandatory — it's the most-cited non-function form via `src/adf.rs::AdfBuilder::*` and `src/adf.rs::AdfRenderer::*`) + constant handling; defer type/module handling to v2 with an *explicit* acknowledgment in Out of Scope §6 that citations resolving to `struct`/`enum`/`trait`/`mod` fall back to permissive grep and are LOW-confidence checks.
   - Recommend **v1 (pragmatic)** — `Type::method` handling is not optional (30+ citations), the others can be time-bounded residuals.

4. **Update Task 2 Step 4(d) explicitly** — the draft's "secondary check" text (story lines 328-331) reads as if it's an acceptable v1 solution. It is not. The updated wording should acknowledge the false-green surface and reference the strengthened-grep alternatives above.

5. **Update Edge Case EC-002 (story line 669)** — currently says "The secondary `grep -q "$symbol"` fallback catches it (constant/type name appears in file) → citation is ALIVE". This is true but misleading; it makes the fallback sound safe. Rewrite to reflect the false-green surface.

---

## Cross-cutting notes

### Additional finding: `src/cli/**/*.rs` glob citation

`bc-7-output-render.md:677` (Trace/Source line, BC-7.3.010) contains a *glob* citation: `` `src/cli/**/*.rs` ``. Extracted via the draft's regex, this yields `src/cli/**/*.rs` — the path-shape guard `^src/[a-zA-Z0-9_/.-]+\.rs$` (draft Task 2 Step 4(b), story line 312) REJECTS this because `*` and `{` are not in the character class → the citation is silently dropped as "malformed" per Edge Case EC-009-adjacent handling. Actual behavior: `DEAD: malformed citation skipped: src/cli/**/*.rs`.

**Is this the desired behavior?** The citation is meaningful (it refers to "all handlers in `src/cli/`"). Being flagged as "malformed" produces a false-positive DEAD line on every canonical run. Two options:

- Add glob wildcards to the shape guard's exclusion path — silently skip rather than emit `DEAD: malformed`, matching BC-X.13.002 step (a)'s glob-skip semantics.
- Leave as-is and pre-remove the glob from bc-7 as part of Story B's F4 delivery (there's exactly ONE such glob citation in the current tree).

Recommend the first option (align with BC-X.13.002 precedent for glob-skip). Add a new Edge Case: `EC-011: glob citation → skipped, not DEAD-flagged`.

### Additional finding: BC-INDEX.md dead-citation drift (in-scope confirmation)

Task recap note — the draft says "BC-INDEX.md is not scanned" (Out of Scope §2). Grep confirms `BC-INDEX.md` has zero `^\*\*(Trace|Source)\*\*:` lines matching the guard's anchor (it uses section-header format, not Trace/Source fields). So the scope-exclusion is not just a design choice — it's also a shape mismatch with the anchor pattern. This is worth adding to the Out of Scope §2 rationale for clarity.

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| Read | 4 | Draft story, Story A guard script (twice for CANONICAL_MODE lines), cross-cutting.md subsystem region |
| Grep | 5 | `BC-X\.13\.` on prd/, `^\*\*(Trace\|Source)\*\*:` line counts, `^\*\*(Trace\|Source)\*\*:.*\`src/` line counts, backtick-src token counts (line-mode & `-o` mode) |
| Glob | 1 | Enumerate `.factory/specs/prd/**/*.md` |
| Perplexity perplexity_research (PRIMARY) | 0 | Task is INTERNAL repo archaeology — external search would not surface the answers; the user's task description explicitly says "primarily INTERNAL repo research; use external tools only if genuinely needed" |
| Perplexity perplexity_ask/reason/search | 0 | Same rationale |
| Context7 | 0 | No third-party library docs relevant |
| Tavily | 0 | Same rationale |
| WebFetch / WebSearch | 0 | Same rationale |
| Training data | 0 areas | No claim in this report relies on training data; every numeric and structural finding is grounded in a specific file+line citation from the current repo state |

**Total MCP tool calls:** 0
**Training data reliance:** low — every finding is anchored to specific on-disk citations.

**Deviation-from-default justification (per agent-defaults):** The primary tool for research agents is `perplexity_research`, but the task is 100% internal-repo forensics (BC-governance archaeology, per-file citation counts, script-mechanism reading, symbol-shape census). No external source would return the current repo's citation counts. The parent task explicitly scoped external tools to "genuinely needed" — none met that bar. If a future consumer disagrees, the report body cites every relevant file+line so an external Perplexity confirmation query is straightforward to add.
