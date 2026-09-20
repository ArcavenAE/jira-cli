# Documentation Drift Audit — 2026-09-19 (develop @ 3d9ca35e)

Scope: CLAUDE.md (priority), docs/specs/, docs/adr/, .factory/specs/architecture/decisions/,
README.md. Focused on cycle-008 "oauth-surface-correctness" fallout (S1-S5, PRs #832-836,
#843, #844, ADR-0026) plus a spot-check of "Known Size Deviations" LOC figures.

Read-only audit. No files modified.

---

## Finding 1 — CLAUDE.md Gotchas: ADR-0026's gateway-routing invariant is completely undocumented

**Severity: HIGH — semantic gap, not just stale text.**
**Fix type: MANUAL-REVIEW (needs a new Gotchas bullet, not a mechanical edit).**

CLAUDE.md's Gotchas section has a bullet for ADR-0009 ("`handle_open` uses `instance_url()`, not
`base_url()`"), but has **zero** mention of its mirror-image, ADR-0026 Decision 1 (accepted
2026-09-17): under OAuth, every API call — platform, JSM, Assets — MUST use `base_url()`
(the `api.atlassian.com/ex/jira/{cloudId}` gateway), never `instance_url()`. This closed a real,
previously-shipped bug where seven call sites (`list_service_desks`, `list_request_types`,
`get_request_type_fields`, `list_queues`, `get_queue_issue_keys`, `create_jsm_request`,
`get_or_fetch_workspace_id`) used `get_from_instance`/`post_to_instance` and 401'd under live
OAuth (invisible under API-token auth and under every existing wiremock test, since
`JiraClient::new_for_test` sets `base_url == instance_url`).

Confirmed via `git show 578a7848`/`fc608cd3` and
`.factory/specs/architecture/decisions/ADR-0026-oauth-3lo-gateway-routing-invariant-and-granular-jira-software-scopes.md`
§Decision 1. `grep -n "get_from_instance\|instance_url\|base_url()" CLAUDE.md` returns only the
pre-existing ADR-0009 line and the `JR_BASE_URL` env-var table row — no ADR-0026 pairing.

This matters going forward: any new JSM/Assets call site added without reading ADR-0026 could
silently reintroduce the same class of bug (it stayed invisible for a full release cycle). Given
CLAUDE.md already documents the "half" of this invariant (ADR-0009), the natural, low-risk fix is
a new Gotchas bullet stating the ADR-0026 invariant symmetrically, citing the ADR file and the
seven-call-site fix. Left as manual-review because it requires judgment about phrasing/placement,
not just updating a stale number.

---

## Finding 2 — CLAUDE.md never documents `classify_401_body` / the post-refresh "double fault" scope reclassification, or the `rewrite_agile_scope_error` scope-hint rewriting used by board/sprint/init/issue-list

**Severity: MEDIUM-HIGH — undocumented auth-error-handling behavior that AI agents/contributors would otherwise have to rediscover from source.**
**Fix type: MANUAL-REVIEW.**

Two related, cycle-008-introduced behaviors have no CLAUDE.md coverage at all:

1. `classify_401_body` (`src/api/client.rs::classify_401_body`, extracted in PR #836,
   "F-WAVE-1"): the single shared decision point that turns a 401 body into
   `InsufficientScope` (if it contains "scope does not match", case-insensitive) or
   `NotAuthenticated` otherwise. It is now called at **three** sites: pre-refresh (first 401,
   pre-existing since S-3.03), and **two new post-refresh/-reconcile retry sites** that fix the
   "double fault" case — a token that refreshes successfully but is still under-scoped. Before
   PR #836, the post-refresh 401 path hardcoded `NotAuthenticated` regardless of body content,
   which would have told a user to `jr auth refresh` when refreshing again can never fix a scope
   problem.

2. `rewrite_agile_scope_error`/`is_insufficient_scope_error` (`src/cli/board.rs`, used by
   `board.rs`, `sprint.rs`, `init.rs`, and `issue/list.rs`): rewrites a generic
   `InsufficientScope` message into a granular, endpoint-specific scope hint (e.g.
   `"read:board-scope.admin:jira-software and read:project:jira"` for `get_board_config`) for
   every Agile API 401. `fc608cd3` further hardened this to scan the full `anyhow` error chain,
   not just the top-level error.

`grep -n "classify_401_body\|rewrite_agile_scope_error\|get_board_config\|board-scope" CLAUDE.md`
returns nothing. The one existing related bullet —
`- **Atlassian's expired-token 401 has no machine-readable signal:** ... Auto-refresh (S-3.03)
therefore triggers on blanket-401 ..., not substring-match or header inspection.` — is adjacent
territory but doesn't cover either of the above; see Finding 3 for whether that bullet itself
needs a correction.

Recommend a new Gotchas bullet (or an addendum to the existing "expired-token 401" bullet)
covering: (a) the pre-refresh scope-mismatch short-circuit (skips refresh entirely, has existed
since S-3.03 — not new), (b) the new post-refresh/post-reconcile double-fault reclassification
(cycle-008), and (c) the `rewrite_agile_scope_error` granular-hint mechanism and which four call
sites use it (`board.rs`, `sprint.rs`, `init.rs`, `issue/list.rs`).

---

## Finding 3 — Existing "expired-token 401 has no machine-readable signal" bullet is imprecise given `classify_401_body`, but not newly wrong

**Severity: LOW.**
**Fix type: automated-fixable (wording tweak) if the team wants to close it, otherwise skippable.**

The bullet reads: *"Auto-refresh (S-3.03) therefore triggers on blanket-401 (`gh` CLI pattern),
not substring-match or header inspection."* Taken literally this now undersells the substring
match that gates the decision at two points:

- Pre-refresh: a 401 containing "scope does not match" **skips refresh entirely** and returns
  `InsufficientScope` immediately (this exact behavior has existed since the original S-3.03
  commit `597dd23c`/`77c0e812` — it is not a cycle-008 change, so this is pre-existing
  imprecision, not new drift).
- Post-refresh (cycle-008, PR #836): the retry's 401 body is now also substring-matched via
  `classify_401_body` rather than assumed to be `NotAuthenticated`.

The bullet's actual claim — "refresh is *attempted* on a blanket 401, not gated by
substring/header inspection *of which error to surface after a successful non-refreshable
failure*" — is defensible but easy to misread as "no substring matching happens anywhere in this
path," which is no longer true (arguably was already slightly imprecise pre-cycle-008 too, since
the pre-refresh scope check already substring-matched). Low severity since the core claim (no
`WWW-Authenticate` header, no `code` field) is still accurate. Worth a one-sentence addendum
pointing at `classify_401_body` rather than a rewrite.

---

## Finding 4 — `docs/specs/oauth-scopes-configurable.md` pins a now-obsolete 4-scope literal with no "historical" marker

**Severity: LOW.**
**Fix type: automated-fixable** (add a one-line "historical, superseded" note — same pattern the
repo already uses elsewhere, e.g. `docs/specs/issue-create-preflight-guards.md`, which CLAUDE.md
itself labels "historical; describes the now-superseded combined-guard shape").

`docs/specs/oauth-scopes-configurable.md` line 126 pins:
`DEFAULT_OAUTH_SCOPES` content is pinned to
`"read:jira-work write:jira-work read:jira-user offline_access"` — a 4-scope set. The constant
has grown twice since (5→8 in `85c3ed5b` adding `write:servicedesk-request`/JSM+CMDB scopes, then
8→16 in cycle-008). This is an original feature-design spec (correctly describing the
point-in-time design when the configurability mechanism was built), not a living reference, so
it's expected to age — but unlike `issue-create-preflight-guards.md`, it carries no marker saying
so, and CLAUDE.md's own citation-discipline convention (last Gotchas bullet, "Citation form in
spec/CLAUDE.md") implies specs should flag known-superseded content. Cheap, low-risk fix: add a
one-line note near the top pointing at `src/api/auth.rs::DEFAULT_OAUTH_SCOPES` as the live source
of truth and ADR-0026 as the scope-expansion history.

---

## Finding 5 — `Known Size Deviations` LOC figures: one meaningfully stale, rest close enough

**Severity: LOW (for the one flagged), informational for the rest.**
**Fix type: automated-fixable** (re-measure + bump the documented figure, following the file's
own existing "re-measured" convention).

Spot-checked every file listed in CLAUDE.md's "Known Size Deviations" section against current
`wc -l` on develop tip:

| File | CLAUDE.md figure (as-of date) | Actual (2026-09-19) | Delta |
|---|---|---|---|
| `cli/issue/list.rs` | ~2,012 (2026-08-25) | 2,057 | +45 (~2%) |
| `cli/issue/create.rs` | ~1,253 (2026-08-31) | 1,304 | +51 (~4%) |
| `cli/issue/edit.rs` | ~3,287 (2026-09-16) | 3,287 | 0 |
| `cli/issue/workflow.rs` | ~1,277 | 1,272 | -5 |
| `cli/component.rs` | ~1,800 | 1,796 | -4 |
| `cli/issue/attachments.rs` | ~3,472 (2026-08-25) | 3,467 | -5 |
| `cli/mod.rs` | ~1,453 (2026-09-16) | 1,453 | 0 |
| `cli/issue/helpers.rs` | ~1,113 (2026-08-25) | 1,120 | +7 |
| `cli/issue/field_resolve.rs` | ~2,269 (2026-09-14) | 2,267 | -2 |
| `cli/issue/jsm_create.rs` | ~1,341 (2026-09-14) | 1,341 | 0 |
| `cli/field.rs` | ~1,901 (2026-09-16) | 1,901 | 0 |
| `cli/auth/login.rs` | ~1,869 (2026-09-16) | 1,869 | 0 |
| **`cli/auth/tests/mod.rs`** | **~2,484 (2026-09-16)** | **2,570** | **+86 (~3.5%)** |

Everything except `cli/auth/tests/mod.rs` is within normal noise of its documented date (most
files haven't been touched since their last "re-measured" pass, or moved by single-digit lines).
`cli/auth/tests/mod.rs` grew ~86 lines since the 2026-09-16 maintenance-sweep measurement,
attributable to `5f718d13` (`fix(auth): expand OAuth scopes for Agile API parity`, part of
cycle-008 S1). Not urgent (the bullet already explicitly disclaims itself as "not a handler,"
documented for consistency only), but if a doc-fix PR is opened for Findings 1-2, bumping this
figure in the same PR is essentially free.

---

## Finding 6 — README.md: no drift found

**Severity: N/A — verification only, nothing to fix.**

Checked README.md's OAuth scope description (lines 161-188) against `src/api/auth.rs`'s live
`DEFAULT_OAUTH_SCOPES`: all 16 scopes are present and correctly attributed to their command
families (`manage:jira-project` → `jr component`, the three `*board-scope*` scopes → `jr board`,
`read:sprint:jira-software` → `jr sprint`, the three granular platform-read scopes called out as
"required alongside the classic scopes above"). Count reconciles exactly (3+2+2+1+1+3+1+3=16).
`auth switch`/`--profile` rejection, `auth login`/`refresh`/`logout`/`remove` flag tables, and the
DPAPI-fallback note also check out against current behavior. No command/flag references found
that reference retired or renamed surface. CHANGELOG.md's `[Unreleased]` section is also already
correctly updated with the 16-scope re-consent note (commit `3d9ca35e`) and the granular
Agile-scope-hint changelog entries (both cross-checked, consistent with source).

---

## Summary / recommendation

Top actionable items, ranked:

1. **Finding 1 (HIGH)** — add an ADR-0026 Gotchas bullet mirroring the existing ADR-0009 one.
   This is the one gap with real "someone reintroduces a shipped bug" risk, since CLAUDE.md is
   the primary onboarding surface for both humans and AI agents adding new JSM/Assets call sites.
2. **Finding 2 (MEDIUM-HIGH)** — add a Gotchas bullet (or extend the existing 401 bullet) for
   `classify_401_body`'s double-fault reclassification and `rewrite_agile_scope_error`'s granular
   scope-hint rewriting. Both are now load-bearing, tested behavior with zero doc surface.
3. **Finding 5 (LOW)** — bump `cli/auth/tests/mod.rs`'s LOC figure; trivial, bundle with #1/#2 if
   a PR is opened.
4. **Finding 4 (LOW)** — add a one-line "historical/superseded" marker to
   `docs/specs/oauth-scopes-configurable.md`, matching the existing pattern used elsewhere.
5. **Finding 3 (LOW)** — optional one-sentence addendum to the existing 401 bullet; can be folded
   into #2's edit rather than done separately.

**Worth a doc-fix PR this sweep?** Yes, for #1 + #2 together (plus #5 for free) — they're pure
Markdown edits to CLAUDE.md's Gotchas section, no code/behavior risk, and close a real
onboarding/safety gap around the OAuth 3LO routing invariant that the codebase itself treats as
important enough to warrant an ADR. #4 is worth bundling in if the same PR is already touching
docs. None of the findings require touching `src/`, `.factory/`, or any BC/ADR content itself
(ADR-0026 is accurate and complete on its own — the gap is purely CLAUDE.md's failure to
surface/cite it).
