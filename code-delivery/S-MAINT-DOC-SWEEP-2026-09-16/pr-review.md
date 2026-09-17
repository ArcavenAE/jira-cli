# PR #825 — Fresh-Eyes PR Review

**PR:** docs: reconcile README + CLAUDE.md with shipped surface (maintenance sweep 2026-09-16)
**Branch:** `docs/maintenance-sweep-2026-09-16` @ d694ad3a → `develop`
**Size:** 23 insertions / 6 deletions, 2 files (`CLAUDE.md`, `README.md`)
**Mergeable:** MERGEABLE
**Reviewer:** pr-reviewer (fresh-eyes, diff + description + CI evidence only)

## Verdict: APPROVE

Merge-ready pending explicit human go-ahead and the one still-pending CI job (`Test (windows-latest)`).

> Note: Per caller's explicit instruction ("Do NOT merge, do NOT approve via `gh`"),
> the formal `gh pr review --approve` was intentionally NOT posted. This artifact
> records the verdict; the human retains manual control of the GitHub review action.

## Findings

None. No BLOCKING, no WARNING, no NIT.

| Severity | Category | Finding | Suggestion |
|----------|----------|---------|------------|
| — | — | No issues found | — |

## What was verified (no rubber-stamping)

### CI status (run 35178374551)
All required checks GREEN except one pending:
- PASS: Test (ubuntu-latest), Test (macos-latest), Clippy (ubuntu + windows), Format,
  MSRV 1.88.0, Deny, Secret Scan (gitleaks), **Spec Guards**, Coverage,
  Mutation Test Plan + 8 shards + Aggregate, Signing Injection Guard, dependency-review.
- PENDING: **Test (windows-latest)** — sole outstanding job.
- The `claude_md_citations` guard rides the Test job; confirmed green on ubuntu + macos
  (PR body reports 61/61 passing).

### Accuracy — LOC figures (exact via `wc -l`, checked against develop tip; doc-only PR so src is identical)
- `cli/mod.rs` → 1453 ✓ (claim ~1,453)
- `cli/issue/comments.rs` → 64 ✓ (claim ~64)
- `cli/issue/edit.rs` → 3287 ✓ (claim ~3,287)
- `cli/field.rs` → 1901 ✓ (new entry ~1,901)
- `cli/auth/login.rs` → 1869 ✓ (new entry ~1,869)
- `cli/auth/tests/mod.rs` → 2484 ✓ (new entry ~2,484)

### Accuracy — behavioral/surface claims
- `sprint list` header = `["ID", "State", "Name", "End Date"]` (src/cli/sprint.rs:178) —
  End Date shown, Start date omitted. New CLAUDE.md wording CORRECT; fixes the stale
  "omits start/end dates" claim. ✓
- `jr version` note: no `jr version` subcommand exists (only clap-builtin `-V`/`--version`).
  New wording accurate. ✓
- README `jr component list/create/edit/delete/rename` — subcommands + cited flags
  (`--move-to`/`--orphan`/`--yes`, rename `--project`/`--all-projects`/`--dry-run`)
  confirmed in src/cli/mod.rs. ✓
- README `jr issue attachment download` — `--id`/`--all`/`--newest`, `--out`/`--out-dir`,
  `--filter`, `--force` confirmed. ✓
- README `jr issue attachment upload` — `--replace-existing`, `--public`/`--internal`,
  `--dry-run` confirmed. ✓
- README `jr issue attachment delete` — three forms (AID / `--issue KEY --older-than <DUR>` /
  `--yes`, `--dry-run`) confirmed. ✓
- README completions "bash, zsh, fish, elvish, powershell" — `clap_complete = "4"`, whose
  `Shell` enum is exactly {Bash, Elvish, Fish, PowerShell, Zsh}. Complete and accurate. ✓

### No new inaccuracies / no dead citations
- Every newly-added backtick file-path citation (`src/cli/field.rs`, `src/cli/auth/login.rs`,
  `src/cli/auth/tests/mod.rs`, `src/cli/sprint.rs`) resolves to a real file.
- The CLAUDE.md dead-citation CI guard (`tests/claude_md_citations.rs`) is green on ubuntu + macos.
- Diff is confined to the two documentation files; blast radius nil (no compiled path affected).

## Checklist coverage
1. Diff coherence — PASS (all changes are doc reconciliation, on-topic).
2. Description accuracy — PASS (PR body finding table matches the diff).
3. Test coverage — N/A (doc-only); citation guard green.
4. Demo evidence — N/A (doc-only maintenance PR).
5. Commit quality — `docs:` conventional prefix, appropriate.
6. Diff size — PASS (29 lines total, well under 500).
7. Missing changes — none detected.
8. Dependency status — none (no upstream PRs).
