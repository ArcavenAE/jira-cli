# PR #710 — `jr component rename` (S-608-1) — Fresh-Eyes Pre-Merge Review

**Verdict: APPROVE (mergeable).**
No BLOCKING or HIGH findings. Diff scope: 5 files, +4215/-3. Reviewed against
BC-8.3.001–007, story S-608-1 ACs (18), and the literal AC command strings.

> Note: GitHub verdict was NOT posted. The human operator explicitly instructed
> "report to me — do NOT file a GitHub approval" (same-account classifier blocks
> agent self-approval; human authorizes merge). This artifact is the review of
> record; no `gh pr review` was issued by design.

## Independent verification
- Reran the rename integration suite in the worktree: **38/38 pass (1.03s)**, tree compiles.
- Did not re-run full workspace suite/clippy/fmt — badge + CI cover those.

## CLI-contract scrutiny (STEP45-MISSED-CONTRACT-BUGS class) — PASS
- `old`/`new` positionals carry `allow_hyphen_values = true` (correct for free-text names).
- `project: Option<String>` ⨉ `all_projects: bool` are `conflicts_with`-paired →
  local both-supplied = clap exit 2 (AC-013 Part A).
- Neither-supplied = application-level `JrError::UserError` exit 64 (NOT `ArgGroup::required`),
  per BC-8.3.005 / DEC-188.
- Global-position `--project` + `--all-projects` footgun guarded: exit 64, zero HTTP,
  message names both flags + "supply exactly one". Test pins exit code, message, and
  `received_requests().is_empty()`.
- Numeric-OLD single-project confirming-GET + project-mismatch message
  (`"Component 10042 belongs to project B, not A."`) and always-project-qualified not-found
  message match ACs byte-for-byte; PUT `.expect(0)`.
- Numeric-OLD under `--all-projects` rejected pre-flight before `list_projects` (zero HTTP),
  live and `--dry-run` (AC-007/AC-012).
- Case-only rename never short-circuits; PUT always fires post-resolution (AC-014/015).
- Name collision surfaced verbatim (400, exit 1), no client-side pre-check (AC-016).
- PUT-race 404 → `ApiError` exit 1, distinct from resolver exit-64 (AC-017).

## Conventions — PASS
- JSON render invariant #526: success/failure JSON paths route through `output::render_json`.
- No let-chains, no `#[allow]`, no `to_string_pretty`. Single `.expect()` is an
  unreachable-by-construction internal invariant with a clear message.
- Conventional commits throughout.
- Partial-failure exit 1 via bare `anyhow` (avoids UserError's 64) — correct, tested (AC-009).

## Test quality — PASS (non-tautological)
Exact `body_json` PUT matches, per-endpoint `.expect(N)` call-count pins, zero-HTTP
`received_requests().is_empty()` assertions, dry-run/live discovery-scope-parity test,
fail-closed intra-project-duplicate test, empty-project-field fail-closed test, N=20 scale test.
No coverage hole found in the diff.

## Findings

| Severity | Category | Finding | Disposition |
|----------|----------|---------|-------------|
| LOW | description | `--all-projects --dry-run` JSON adds a `wouldFail` key beyond BC-8.3.004's literal `{"dryRun":true,"targets":[...]}`. Additive superset; `jq '.targets'` unaffected. | Documented in-code as deferred F5 wording. Non-blocking. |
| LOW | coherence | `--all-projects --dry-run` exits 1 when any project is ambiguous (non-zero on a preview). | Deliberate — preview predicts live exit-1; documented. Non-blocking; flag to human if dry-run-always-0 is desired. |
| LOW | coherence | Two "both-scope" forms differ in exit code: local `--project X --all-projects` → 2 (clap); global `--project X … --all-projects` → 64 (app guard). | Inherent to clap global-propagation; exit-64 path is the safer outcome, documented + tested. Non-blocking. |
| NIT | output | All-projects live table summary line prints `"{n} renamed"` without echoing failed count (per-project `FAILED —` lines + JSON `failed[]` do carry it). | Cosmetic. |

## Recommendation
Safe to merge to `develop` on human authorization. The three LOW items are documented
deferrals / un-specced-corner behaviors chosen for safety, not defects.
