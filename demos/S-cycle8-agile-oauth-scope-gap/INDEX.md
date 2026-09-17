# S-cycle8-agile-oauth-scope-gap Demo Evidence

Story: DEFAULT_OAUTH_SCOPES full-parity finalization — +`manage:jira-project` + 7 granular
Jira-Software/Agile scopes, growing the embedded `jr` OAuth app's default scope set from 8 to
16 scopes (BC-1.3.023, ADR-0026 Decision 2/2a)
Branch: `fix/cycle8-agile-oauth-scopes`
Head: `4f452445f95e07eedc9be8ad83ed580d30e8cb79`
Binary: n/a (no CLI binary invocation — evidence is a unit-test pinning-literal proof)
Captured: 2026-09-17

## Why this is a test-evidence demo, not a live CLI demo

This story is a single `const`/string-literal edit to `DEFAULT_OAUTH_SCOPES` in
`src/api/auth.rs`, plus its companion pinning-test update in `src/cli/auth/tests/mod.rs` and a
CHANGELOG entry (`tdd_mode: facade` per the story frontmatter — no new runtime logic, the
pinning test IS the verification mechanism). The scope-set change is only observable at the
OAuth consent screen during a LIVE `jr auth login --oauth` flow — which this project does not
exercise for demo purposes (no live mutations/OAuth flows without explicit approval, per repo
policy: a live login would mint a real OAuth grant and consume a real consent screen). The
honest, reproducible, and CI-equivalent evidence is a captured run of the pinning test that
directly asserts the finalized 16-scope literal, exact ordering and spacing, and the Teams-scope
exclusion — following the same per-story evidence convention as this cycle's siblings
`S-cycle8-assets-workspace-oauth-routing` and `S-cycle8-jsm-servicedeskapi-oauth-routing` (one
subdirectory per story ID, plain-text `cargo test -- --nocapture` captures + this INDEX).

VHS (`/opt/homebrew/bin/vhs`) is available in this environment but was not attempted for this
story: this cycle's sibling story (`S-cycle8-jsm-servicedeskapi-oauth-routing/INDEX.md`) already
documented, same day, that VHS launches cleanly here but produces only a blank recording (no
keystroke ever reaches the terminal — a known sandbox input-delivery failure, also documented for
`S-cycle3-percred-storage`). That finding is moot for this story regardless: there is no
interactive CLI flow to demonstrate at all — the change is a pure string constant with no
executable path that prints anything to a terminal. A VHS recording of `cargo test` output would
add strictly less information than the plain-text capture below.

## Summary

AC-001 through AC-004 (the finalized 16-scope literal, the pinning-test lockstep obligation, the
`manage:jira-project` component-write-gap closure, and the Teams-scope exclusion) are all proven
by one test function, `default_oauth_scopes_pins_the_full_set_with_offline_access`, captured
individually and pinned with the exact 16-scope list. AC-005 (the regression guard — no change
required to `resolve_oauth_scopes`/`build_authorize_url`) is proven both by a passing regression
test and by a direct `git diff` confirming zero lines changed in `src/cli/auth/login.rs`. A
combined run of all 11 OAuth-scope-related unit tests and the full 1487-test `cargo test --lib`
suite serve as the broader regression safety net (0 failures either way). AC-006 (CHANGELOG
entry) is a doc artifact, verified present via `grep` against `CHANGELOG.md` on this branch.
AC-007 (Developer Console release-gate checklist item) is a PR-description process gate, not a
code test — out of scope for this recorder role; it belongs on the PR itself (pr-manager's
responsibility, not yet opened as of this capture).

## Per-AC Evidence

| AC | Demo File | Test Function(s) | Result |
|----|-----------|-------------------|--------|
| AC-001 (finalized 16-scope literal, exact order/spacing) | `ac-001-002-003-004-full-scope-pin.txt` | `default_oauth_scopes_pins_the_full_set_with_offline_access` | ok |
| AC-002 (pinning-test lockstep obligation — updated in same commit as the constant) | `ac-001-002-003-004-full-scope-pin.txt` (same test — this transcript IS the "run green" proof) | `default_oauth_scopes_pins_the_full_set_with_offline_access` | ok |
| AC-003 (`manage:jira-project` present, distinct from `write:jira-work`) | `ac-001-002-003-004-full-scope-pin.txt` (same test, exact-literal + per-scope assertions) | `default_oauth_scopes_pins_the_full_set_with_offline_access` | ok |
| AC-004 (`view:team:teams` / `view:membership:teams` explicitly absent) | `ac-001-002-003-004-full-scope-pin.txt` (same test, two negative assertions) | `default_oauth_scopes_pins_the_full_set_with_offline_access` | ok |
| AC-005 (`resolve_oauth_scopes`/`build_authorize_url` unchanged — regression guard) | `ac-005-regression-guard-unchanged-plumbing.txt` | `resolve_oauth_scopes_inspects_passed_profile_not_active` + direct `git diff` confirmation | ok (test) + confirmed (diff shows zero lines changed in `login.rs`) |
| AC-001..005 combined (all OAuth-scope unit tests, one invocation) | `ac-001-002-003-004-005-combined-scope-suite.txt` | 11 tests: the above 2 + 9 pre-existing `resolve_oauth_scopes`/config-layer tests | ok (11 passed) |
| Full regression safety net (Task 10: `cargo test` full run) | `full-suite.txt` | full `cargo test --lib` suite | ok (1487 passed, 0 failed, 48 ignored — same ignored count as baseline, all pre-existing gated suites) |
| AC-006 (CHANGELOG `[Unreleased] > Changed` entry) | N/A — doc artifact | n/a | present on `fix/cycle8-agile-oauth-scopes`, verified via `grep` (see below) |
| AC-007 (Developer Console RELEASE GATE PR checklist item) | N/A — process gate, not a code test | n/a | belongs on the PR description; not yet opened as of this capture — out of scope for demo-recorder |

## AC-006 verification (doc artifact, no test)

```
$ grep -B2 -A15 "S-cycle8-agile-oauth-scope-gap" CHANGELOG.md
```
(run against `fix/cycle8-agile-oauth-scopes`) confirms a `[Unreleased] > Changed` entry stating:
(a) `DEFAULT_OAUTH_SCOPES` grows from 8 to 16 scopes, naming `manage:jira-project` and all 7
granular Jira-Software/Agile scopes; (b) existing OAuth users will see a re-consent
(`prompt=consent`) prompt on next login or token refresh; (c) this unblocks `jr board`,
`jr sprint`, and `jr component create/edit/delete/rename` under OAuth; (d) an explicit **RELEASE
GATE** note that the Atlassian Developer Console registration for the embedded `jr` OAuth app
MUST be updated with all 8 new scopes before this ships in a tagged release, matching CLAUDE.md's
own "When changing `DEFAULT_OAUTH_SCOPES`" procedure.

## Diff scope confirmation (AC-005 "zero change to login.rs" claim)

```
$ git diff develop...HEAD --stat   # run against fix/cycle8-agile-oauth-scopes
 CHANGELOG.md              |  16 +++++++
 README.md                 |   9 +++-
 src/api/auth.rs           |  38 ++++++++++++++---
 src/cli/auth/tests/mod.rs | 104 ++++++++++++++++++++++++++++++++++++++++++----
 4 files changed, 151 insertions(+), 16 deletions(-)
```

`src/cli/auth/login.rs` is absent from the changed-file list entirely — confirming AC-005's
zero-line-changed claim for `resolve_oauth_scopes`. The `README.md` diff (verified separately) is
the user-facing scope-list doc sync, not a behavior change. The `src/api/auth.rs` diff is scoped
to the `DEFAULT_OAUTH_SCOPES` literal and its doc comment; `build_authorize_url`, elsewhere in the
same file, is untouched (confirmed by reading the function body at commit `4f452445` — it still
consumes the resolved scope string opaquely, with no scope-count-dependent logic).

Task 1's grep for stale literal scope-string assertions outside `src/cli/auth/tests/mod.rs`
(`grep -rn "DEFAULT_OAUTH_SCOPES\|read:jira-work write:jira-work" tests/`) returned no matches —
no other test file needed updating.

## Convention Note

Pattern established by `S-577-3/INDEX.md`, reused by `S-576-5/INDEX.md` and this cycle's Wave-1
siblings `S-cycle8-assets-workspace-oauth-routing/INDEX.md` and
`S-cycle8-jsm-servicedeskapi-oauth-routing/INDEX.md`: one subdirectory per story ID under
`.factory/demos/` (committed to the `factory-artifacts` branch, per this repo's `.gitignore`
comment: "Demo evidence lives in the factory-artifacts branch (`.factory/demos/`), not the
product repo" — `docs/demo-evidence/` is gitignored in the product repo for this reason, added in
#708). An `INDEX.md` plus per-AC `.txt` capture files, each prefixed with a caption block
explaining what the test proves before the raw `cargo test` output. This story follows that exact
convention rather than introducing a new demo-evidence location, since the fix under test has no
interactive CLI surface to record.

**Deviation from generic demo-recorder instructions:** the generic demo-recorder contract calls
for output at `docs/demo-evidence/<STORY-ID>/` committed to the feature branch, with a VHS
`.tape`/`.gif`/`.webm` per AC. This repo has an explicit, established, git-enforced (via
`.gitignore`) convention that supersedes the generic default: demo evidence for internal/
constant-only fixes with no CLI surface lives on the `factory-artifacts` branch under
`.factory/demos/<STORY-ID>/` as plain-text test transcripts, not on the feature branch as VHS
recordings.
