# PR Review — #812 (S-cycle12-jsm-adf-autoconvert)

**VERDICT: APPROVE** (nitpicks only — no CRITICAL/HIGH/MEDIUM findings)

Fresh-eyes pre-merge review. Head `feat/cycle12-jsm-adf-autoconvert` @ `3dadb1ae` → base `develop`.
Reviewed the diff (`gh pr diff 812`, 5 files, +1851/-46), the PR description, and the test evidence.

## Summary

The diff does exactly what the description claims: adds ADF auto-conversion for
`jr issue create --request-type RT --field NAME=VALUE` on the JSM create path, implementing
BC-3.8.019/020/021/022 (ADR-0024) via DQ-6 Option (b) — a parallel `resolved_adf_values`
map plus a pre-computed `is_adf_request` bool on `JsmRequestBuilder`, and an assembly-order
fix in `build()`.

## Checklist (8/8 reviewed)

1. **Diff coherence** — PASS. All 5 files serve the single feature; no unrelated changes.
2. **Description accuracy** — PASS. Code matches the described DQ-6 Option (b) plumbing,
   the `build()` assembly-order fix (only the `self.description` insert moves after the
   `extra_fields` loop), fail-open metadata fetch, and empty-omit semantics.
3. **Test coverage** — PASS. Strong, non-tautological, wiremock-backed. Asserts real ADF
   doc structure, the INV-1 no-raw-newline invariant, empty-omit, OR-accumulation, and the
   AC-013 discriminator (a hinted `:id` object must NOT set `isAdfRequest`). Absence checks
   use `.is_none()`; the C.2 proptest was tightened to kill an explicit-`false` mutant.
4. **Demo evidence** — SKIPPED by explicit human decision (backend/no-UI write-path,
   AC-012 key-only output). Noted, not blocking.
5. **Commit quality** — PASS. Conventional format, on-topic.
6. **Diff size** — PASS with note. +1851/-46 but dominated by tests + CHANGELOG;
   ~996 production lines for a 13-pt L story. Acceptable.
7. **Missing changes** — PASS. BC-3.8.019/020/021/022 each map to passing tests.
8. **Dependency status** — PASS. Story 1 (PR #809) merged in `develop`; the shared
   `is_adf_field_value` predicate exists (`field_resolve.rs:826`, `pub(crate)`) and is
   called with the inner `jira_schema` directly (no double-nesting).

## Correctness / security / maintainability

- Fail-open is infallible by design: `resolve_jsm_adf_extra_fields` has no `Result`, emits
  one static stderr warning (no status/body/token/URL interpolation), degrades to plain
  strings, never exits 64.
- `build()` purity preserved: `is_adf_request = description_is_adf || self.is_adf_request`;
  never inspects value shapes. Backward compatible — old callers pass empty map + `false`,
  and proptests prove byte-identical output.
- GET gating correct: metadata fetch fires iff ≥1 bare (`kind.is_none()`) pair (AC-015(a)).
- Conventions: no let-chains (MSRV-1.85 safe), no lint suppressions, `text_to_adf`-only for
  `--field` consistent with platform Story 1 (`field_resolve.rs:954`), #526 JSON invariant
  unaffected (warning is stderr), best-effort cache writer uses documented model-b idiom.
- Independently re-ran `cargo test --lib jsm` → 31/0 and `cargo test --test issue_create_jsm`
  → 113/0. Green claims confirmed.

## Findings (all non-blocking)

- **NITPICK** (`src/api/jsm/requests.rs`, `build()`): dedicated-flag precedence asymmetry —
  `--field summary=X` overrides `--summary Y` (extra field wins, before loop), but
  `--field description=X` cannot override `--description Y` (dedicated flag wins, moved after
  loop). Deliberate and documented (BC-3.8.008 + EC-3.8.019-4), the intended bug fix; a
  future doc line would help. Not a merge blocker.
- **LOW (pre-existing, not introduced here)**: `src/cache.rs` charset guard is
  `debug_assert!`-only (CWE-22 residual). This PR adds a second call site relying on it;
  both IDs are Jira-API-sourced/CLI-gated. Already accepted; out of scope.

**No blocking findings. Approve.**
