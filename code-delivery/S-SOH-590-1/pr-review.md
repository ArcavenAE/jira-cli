## PR Review — S-SOH-590-1 (quick-dev route, DEC-165)

**Verdict: APPROVE** — no blocking findings.

PR: https://github.com/Zious11/jira-cli/pull/597
Base: `develop` ← Head: `fix/soh-590-http-method-case`
Diff scope: 1 attribute addition (`ignore_case = true`), 3 new dispatch tests, 1 CHANGELOG entry.

---

### 1. Correctness

`ignore_case = true` is the canonical clap 4.x attribute for case-insensitive `ValueEnum` matching. Applied at the `#[arg]` (field) level in `src/cli/mod.rs:127`, NOT on the enum itself — parse-time only:

- No impact on runtime representation of `HttpMethod`.
- No impact on help rendering — `[possible values: get, post, put, patch, delete]` is unchanged (clap prints variant names, not user input).
- No impact on the `From<HttpMethod> for reqwest::Method` impl in `src/cli/api.rs`.
- Lowercase inputs remain valid, confirmed by the regression-guard test `test_parse_api_method_lowercase_delete_dispatches_http_delete`.

**Correctness verdict:** PASS.

---

### 2. Test completeness (VP-590-001)

All three postconditions covered via wiremock HTTP-level `method("DELETE")` dispatch assertions with `.expect(1)`:

| AC | Test | Result |
|----|------|--------|
| AC-001 uppercase DELETE dispatches | `test_parse_api_method_uppercase_delete_dispatches_http_delete` | PASS |
| AC-002 lowercase regression guard | `test_parse_api_method_lowercase_delete_dispatches_http_delete` | PASS |
| AC-003 mixed-case Delete parses | `test_parse_api_method_mixedcase_delete_dispatches_http_delete` | PASS |
| AC-004 clap error eliminated | Implicit in AC-001 + AC-003 `.success()` assertions | PASS |
| AC-005 help text unchanged | No direct snapshot; mechanism guarantees it (see §1) | PASS-by-mechanism |
| AC-006 CHANGELOG entry present | See §3 | PASS |

Red Gate evidence in PR body: cec775e (uppercase + mixed-case FAILED with clap exit 2) → cb3b471 (all 3 PASS after fix). Full suite 2010/2010 green at e45a7bc.

**Test verdict:** PASS.

---

### 3. CHANGELOG

Entry placed under `[Unreleased] > Fixed` in the correct section, above the pre-existing `#571` ADF entry. Cites both `#590` and `#582` as required. Wording accurately describes the user-visible behavior change ("`DELETE`, `delete`, and `Delete` are all accepted") and cites the `curl -X` / `gh api -X` convention.

**CHANGELOG verdict:** PASS.

---

### 4. Architecture rule compliance

- **Enum untouched:** `git diff origin/develop...HEAD -- src/cli/api.rs` produces zero output. `HttpMethod` is byte-for-byte unchanged.
- **No new imports:** the `#[arg]` attribute expansion is entirely clap-derived; no `use` lines added.
- **No forbidden changes:** no changes to auth, HTTP dispatch, error paths, or JSON output surfaces.
- **Diff scope matches DEC-165 F1 TRIVIAL budget:** 3 files, +64/−1 lines total. Well within the "single attribute" envelope.

**Architecture verdict:** PASS.

---

### 5. Commit hygiene

Three commits, all Conventional-Commits formatted with story scope `S-SOH-590-1`, in Red → Green → Docs order:

| SHA | Type | Message |
|-----|------|---------|
| `cec775e` | `test` | `test(S-SOH-590-1): add failing case-insensitive -X method tests (VP-590-001)` |
| `cb3b471` | `fix` | `fix(S-SOH-590-1): accept case-insensitive HTTP methods on jr api -X (closes #590, closes #582)` |
| `e45a7bc` | `docs` | `docs(S-SOH-590-1): add CHANGELOG entry for #590/#582` |

The `closes #590, closes #582` trailer on the fix commit will properly trigger GitHub auto-close on merge for both issues.

**Commit hygiene verdict:** PASS.

---

### Non-blocking observations (NIT)

- The new tests' rustdoc comments still read `"MUST FAIL until ignore_case = true is added"`. These are stale post-fix but useful as Red-Gate provenance; VSDD practice preserves them.
- Only `DELETE` is exercised. The PR body correctly notes the mechanism is identical across all five verbs (`GET`/`POST`/`PUT`/`PATCH`/`DELETE`); a single-verb slice is defensible for F1 TRIVIAL scope. If future paranoia demands, a `POST`-case dispatch test could be added, but not required now.
- Waivers (demo evidence, adversarial review) are properly documented in the PR body per DEC-165.

---

### Final verdict

**APPROVE.** No blocking, major, or minor findings. Safe to merge after `ci-gate` is green. Human merge authorization required per DEC-128 (HELD-FOR-HUMAN-MERGE).
