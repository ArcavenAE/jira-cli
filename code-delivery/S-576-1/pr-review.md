# PR Review — #630 `[S-576-1] jr issue attachment list` — Cycle 2

**Reviewer:** pr-reviewer (fresh-eyes, cognitive-diversity gate)
**Head SHA reviewed:** `e906178ea639557883570eb3a97af8bd65b0270f`
**Verdict:** APPROVE
`covered_sha: e906178ea639557883570eb3a97af8bd65b0270f`

Cycle 1 (REQUEST_CHANGES) flagged only CI infrastructure issues — the `spec-guard`
false-positives and the mutation-testing timeout. Those are resolved: `ci-gate` is now
green and mutation testing passes. The code was CLEAN in Cycle 1 and remains so; the
Cycle-2 delta is targeted mutant-kill tests plus a justified CI timeout bump.

---

## CI Status

`ci-gate` is genuinely **SUCCESS** (pass, 4s — run 29705120305), not pending. All 15
checks green, including:
- Mutation testing: **pass** (1h38m — under the new 120m timeout)
- Spec Guards (BC counts, numeric-count lint, citation checks, mutants policy scope): **pass**
- Test (ubuntu/macos/windows), Clippy (×2), Format, Deny, Coverage, MSRV, Secret Scan,
  Signing Guard, dependency-review: **pass**

## Cycle-2 mutant-kill commit (e906178e) — verified against source at head SHA

1. **`test_format_size_2mb` / `test_format_size_1gb`** — kill the `*`→`+` mutant on
   `const GB: u64 = 1024 * MB` in `src/cli/issue/attachments.rs::format_size`. With the
   mutation GB=1,049,600: 2 MiB (2,097,152) mis-renders as "2.0 GB" and 1 GiB as
   "1023.0 GB". Assertions `"2.0 MB"` / `"1.0 GB"` kill it. CORRECT.

2. **5xx stderr assertions** (`contains("500")` + `!contains("Permission denied")`) —
   kill the `*status == 403`→`true` mutant in `src/api/jira/attachments.rs`. The 403 arm
   emits "Permission denied: cannot access issue …" with status 403; under the mutation a
   500 is re-wrapped as that message. Assertions detect and kill it. CORRECT.

3. **`test_bc_2_7_001_all_filtered_out_empty_stdout_hint_to_stderr`** — kills the `<`
   mutants on the `if n < total` guard inside the `else if filtered.is_empty()` arm
   (attachments.rs:220-224). With 2 PDFs + `mime=image/*`: n=0/total=2. `<`→`==` and
   `<`→`>` both suppress the hint (killed); `<`→`<=` is correctly documented as an
   equivalent/unviable mutation. Also pins empty stdout + exit 0. CORRECT.

4. **ci.yml timeout 90→120** — justified; the actual mutation run took 1h38m, which
   would have exceeded the old 90m ceiling.

## 8-item checklist

| # | Item | Result |
|---|------|--------|
| 1 | Diff coherence | PASS — all 37 files scoped to S-576-1; no unrelated changes |
| 2 | Description accuracy | PASS (minor: new-tests badge reads 14/14; Cycle-2 adds 3 more → 17. Stale badge only, NIT) |
| 3 | Test coverage | PASS — changed logic covered; surviving mutants now killed |
| 4 | Demo evidence | PASS — 7 GIF/WebM pairs + evidence-report.md for all 11 ACs |
| 5 | Commit quality | PASS — conventional format, S-576-1 ID on every commit |
| 6 | Diff size | >500 lines but appropriate for a new-feature story w/ tests + demo assets |
| 7 | Missing changes | PASS — none |
| 8 | Dependency status | PASS — first story in bundle, no upstream deps |

## Findings

| Severity | Category | Finding | Suggestion |
|----------|----------|---------|------------|
| nit | description | New-tests badge reads 14/14 but Cycle-2 adds 3 more (17 total) | Optional: refresh badge. Non-blocking. |

No blocking or warning findings. Cycle 1 cleared the code as CLEAN; the Cycle-2 additions
are targeted, correct mutant-kill tests plus a justified CI timeout bump. No new issues
introduced.

---

## Verified CLEAN (carried from Cycle 1, still accurate)

- **BC-2.7.001**: 6-column table `ID|Filename|Type|Size|Created|Author` in order,
  human-readable sizes, zero-attachment + filter-count hints to stderr, stdout pipe-friendly.
- **BC-2.7.002**: curated JSON via `output::render_json` — `self` omitted,
  `content`→`contentUrl`, `size` raw u64, author curated to `{accountId, displayName}`,
  BTreeMap-alphabetical key order.
- **BC-2.7.003/004/005**: mime/name globs, AND composition, `size-max` with edge cases;
  invalid/unknown filter keys exit 64 before any HTTP.
- **BC-2.7.006**: 404→64, 401→2, 403→1, 5xx→1, network→1, each with actionable stderr.
- **Architecture**: `display_sanitize_filename` (CWE-116) full extended set;
  `pub fn serialize_attachment_curated` + `pub mod attachments` for VP-576-004; #526
  JSON invariant satisfied.
- **Accepted residuals (non-blocking, documented):** P4-001 `#[serde(default)]` deferred
  to S-576-2; SEC-001/002/003 LOW (display-layer / self-DoS / codebase-wide patterns).

**APPROVE** — `covered_sha: e906178ea639557883570eb3a97af8bd65b0270f`
