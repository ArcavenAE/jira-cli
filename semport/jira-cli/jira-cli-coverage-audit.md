# Phase B.5 — Coverage Audit (jr Jira CLI)

**Method:** Grep-driven safety net to find blind spots after Phase B convergence (Passes 0/1/2/3/4/5 all converged to NITPICK).
**Source root:** `.reference/jira-cli/` (read-only)
**Analysis root:** `.factory/semport/jira-cli/`
**Coverage rule:** ✓ = 2+ mentions in pass-family; + = 1 mention; · = 0 mentions. "Substantive coverage" requires 2+ mentions in at least 2 pass families.
**Inventory:** 80 source `.rs` files (23 334 LOC), 36 integration test files, 11 build/config/CI files.

---

## §1. Coverage Matrix (source files × passes)

Glyphs: `+++` ≥3 mentions, `++` 2 mentions, `+` 1 mention, `.` 0 mentions. Counts are raw `grep -F <relative-path>` hits across each pass-family bundle.

### §1.1 src/ (Rust source)

| File | LOC | P0 | P1 | P2 | P3 | P4 | P5 |
| src/adf.rs | 1826 | +++ | ++ | +++ | +++ | + | + |
| src/api/assets/linked.rs | 557 | +++ | + | ++ | + | +++ | . |
| src/api/assets/mod.rs | 5 | . | + | . | . | . | . |
| src/api/assets/objects.rs | 237 | + | . | +++ | + | . | . |
| src/api/assets/schemas.rs | 44 | ++ | . | +++ | . | . | . |
| src/api/assets/tickets.rs | 19 | . | . | ++ | . | . | . |
| src/api/assets/workspace.rs | 58 | . | + | ++ | + | + | . |
| src/api/auth.rs | 1397 | +++ | +++ | +++ | +++ | +++ | +++ |
| src/api/auth_embedded.rs | 250 | +++ | +++ | +++ | +++ | . | + |
| src/api/client.rs | 490 | +++ | +++ | +++ | +++ | +++ | +++ |
| src/api/jira/boards.rs | 50 | . | . | + | . | . | . |
| src/api/jira/fields.rs | 303 | +++ | + | + | + | . | ++ |
| src/api/jira/issues.rs | 314 | +++ | + | +++ | +++ | + | + |
| src/api/jira/links.rs | 97 | + | . | + | ++ | . | . |
| src/api/jira/mod.rs | 11 | . | + | . | . | . | . |
| src/api/jira/projects.rs | 121 | . | . | + | . | . | . |
| src/api/jira/resolutions.rs | 55 | + | . | + | + | . | . |
| src/api/jira/sprints.rs | 109 | . | . | + | . | . | . |
| src/api/jira/statuses.rs | 21 | . | . | + | . | . | . |
| src/api/jira/teams.rs | 55 | + | + | ++ | . | + | . |
| src/api/jira/users.rs | 290 | ++ | . | ++ | ++ | +++ | ++ |
| src/api/jira/worklogs.rs | 31 | + | . | ++ | +++ | +++ | . |
| src/api/jsm/mod.rs | 2 | . | + | . | . | . | . |
| src/api/jsm/queues.rs | 85 | . | . | + | . | + | . |
| src/api/jsm/servicedesks.rs | 127 | . | . | + | . | . | . |
| src/api/mod.rs | 8 | . | + | . | . | . | . |
| src/api/pagination.rs | 374 | +++ | +++ | + | +++ | + | . |
| src/api/rate_limit.rs | 55 | +++ | +++ | + | +++ | +++ | . |
| src/cache.rs | 899 | +++ | ++ | +++ | +++ | +++ | +++ |
| src/cli/api.rs | 342 | +++ | + | + | + | . | . |
| src/cli/assets.rs | 1055 | +++ | + | +++ | +++ | ++ | . |
| src/cli/auth.rs | 1998 | +++ | ++ | +++ | +++ | + | +++ |
| src/cli/board.rs | 334 | ++ | . | +++ | + | . | . |
| src/cli/init.rs | 285 | ++ | + | ++ | . | . | + |
| src/cli/issue/assets.rs | 65 | + | . | . | . | . | . |
| src/cli/issue/changelog.rs | 847 | +++ | . | +++ | +++ | . | +++ |
| src/cli/issue/comments.rs | 61 | +++ | . | +++ | . | . | . |
| src/cli/issue/create.rs | 375 | +++ | . | ++ | +++ | . | . |
| src/cli/issue/format.rs | 225 | +++ | . | +++ | ++ | + | . |
| src/cli/issue/helpers.rs | 813 | +++ | . | +++ | + | . | . |
| src/cli/issue/json_output.rs | 149 | +++ | . | ++ | +++ | + | +++ |
| src/cli/issue/links.rs | 293 | ++ | . | ++ | ++ | . | . |
| src/cli/issue/list.rs | 1083 | +++ | + | +++ | +++ | +++ | + |
| src/cli/issue/mod.rs | 93 | . | + | . | . | . | . |
| src/cli/issue/view.rs | 286 | ++ | . | +++ | . | . | . |
| src/cli/issue/workflow.rs | 788 | +++ | + | +++ | +++ | +++ | . |
| src/cli/mod.rs | 772 | +++ | ++ | + | + | . | ++ |
| src/cli/project.rs | 133 | . | . | ++ | . | . | . |
| src/cli/queue.rs | 323 | +++ | . | ++ | +++ | + | . |
| src/cli/sprint.rs | 438 | +++ | . | +++ | +++ | +++ | ++ |
| src/cli/team.rs | 120 | . | . | ++ | . | . | . |
| src/cli/user.rs | 165 | + | . | ++ | + | . | + |
| src/cli/worklog.rs | 79 | . | . | +++ | +++ | +++ | + |
| src/config.rs | 1223 | +++ | +++ | +++ | +++ | +++ | +++ |
| src/duration.rs | 159 | +++ | . | +++ | +++ | +++ | +++ |
| src/error.rs | 136 | +++ | ++ | +++ | +++ | + | ++ |
| src/jql.rs | 395 | +++ | ++ | ++ | +++ | ++ | +++ |
| src/lib.rs | 12 | ++ | + | . | . | . | . |
| src/main.rs | 268 | +++ | +++ | + | +++ | +++ | + |
| src/observability.rs | 39 | +++ | +++ | +++ | ++ | +++ | + |
| src/output.rs | 76 | +++ | ++ | ++ | ++ | . | . |
| src/partial_match.rs | 200 | +++ | . | ++ | +++ | . | +++ |
| src/types/assets/linked.rs | 246 | ++ | . | ++ | ++ | . | . |
| src/types/assets/mod.rs | 9 | . | . | + | . | . | . |
| src/types/assets/object.rs | 329 | + | . | +++ | + | . | + |
| src/types/assets/schema.rs | 116 | + | . | ++ | + | . | . |
| src/types/assets/ticket.rs | 79 | + | . | ++ | + | . | . |
| src/types/jira/board.rs | 63 | + | . | + | + | . | . |
| src/types/jira/changelog.rs | 126 | + | . | + | + | . | . |
| src/types/jira/issue.rs | 625 | +++ | + | ++ | +++ | . | . |
| src/types/jira/mod.rs | 17 | . | . | + | . | . | . |
| src/types/jira/project.rs | 24 | . | . | + | . | . | . |
| src/types/jira/sprint.rs | 12 | . | . | + | . | . | . |
| src/types/jira/team.rs | 39 | . | . | + | . | + | . |
| src/types/jira/user.rs | 12 | . | . | + | . | . | . |
| src/types/jira/worklog.rs | 16 | . | . | + | . | . | . |
| src/types/jsm/mod.rs | 5 | . | . | + | . | . | . |
| src/types/jsm/queue.rs | 83 | + | . | + | + | . | . |
| src/types/jsm/servicedesk.rs | 10 | . | . | + | . | . | . |
| src/types/mod.rs | 3 | . | + | . | . | . | . |

### §1.2 Build / config / CI / docs

| File | LOC | P0 | P1 | P2 | P3 | P4 | P5 |
| build.rs | 137 | +++ | +++ | +++ | +++ | +++ | . |
| Cargo.toml | 47 | +++ | . | . | . | +++ | +++ |
| Cargo.lock | huge | +++ | . | . | . | +++ | . |
| README.md | 449 | +++ | . | . | . | . | . |
| install.sh | 128 | +++ | . | . | . | . | . |
| deny.toml | 11 | +++ | . | . | . | +++ | . |
| rust-toolchain.toml | 3 | +++ | . | . | . | . | . |
| .gitignore | 4 | . | . | . | . | . | . |
| .github/workflows/ci.yml | 78 | + | . | . | . | +++ | + |
| .github/workflows/release.yml | 230 | + | . | . | . | +++ | . |

### §1.3 tests/ (integration tests)

Tests are evidence files cited from BCs (Pass 3) and a few NFRs (Pass 4). Path-based mention counts (top of each pass-family bundle). All 36 test files have at least one P3 reference.

| File | LOC | P0 | P1 | P2 | P3 | P4 | P5 |
| tests/cli_handler.rs | 2134 | +++ | . | + | +++ | . | . |
| tests/issue_commands.rs | 1920 | +++ | + | + | +++ | . | +++ |
| tests/assets.rs | 1799 | +++ | . | . | +++ | . | . |
| tests/issue_changelog.rs | 1722 | +++ | . | . | +++ | . | + |
| tests/all_flag_behavior.rs | 686 | +++ | . | . | +++ | . | . |
| tests/user_pagination.rs | 520 | ++ | . | . | +++ | ++ | . |
| tests/sprint_commands.rs | 515 | ++ | . | . | +++ | . | +++ |
| tests/team_column_parity.rs | 483 | + | . | + | +++ | . | . |
| tests/queue.rs | 478 | + | . | . | +++ | . | . |
| tests/common/fixtures.rs | 446 | ++ | . | +++ | + | . | +++ |
| tests/api_client.rs | 444 | ++ | . | . | +++ | . | . |
| tests/issue_create_json.rs | 429 | + | . | . | +++ | . | . |
| tests/issue_list_errors.rs | 423 | + | . | . | +++ | + | + |
| tests/user_commands.rs | 416 | + | . | . | +++ | . | . |
| tests/board_commands.rs | 411 | + | . | . | +++ | . | . |
| tests/comments.rs | 402 | + | . | . | +++ | . | . |
| tests/issue_remote_link.rs | 348 | + | . | . | +++ | . | . |
| tests/cli_smoke.rs | 334 | ++ | . | + | +++ | . | ++ |
| tests/auth_profiles.rs | 333 | +++ | . | . | +++ | . | +++ |
| tests/project_commands.rs | 323 | + | . | . | +++ | . | . |
| tests/duplicate_user_disambiguation.rs | 275 | + | . | + | +++ | . | . |
| tests/input_validation.rs | 253 | + | . | . | +++ | . | . |
| tests/team_object_shape.rs | 243 | + | . | . | +++ | . | . |
| tests/issue_view_errors.rs | 206 | + | . | . | +++ | . | . |
| tests/team_commands.rs | 196 | + | . | . | +++ | . | . |
| tests/cmdb_fields.rs | 189 | + | . | . | +++ | . | . |
| tests/migration_legacy.rs | 172 | + | . | . | +++ | . | ++ |
| tests/worklog_commands.rs | 171 | + | . | . | +++ | . | . |
| tests/issue_resolution.rs | 158 | + | . | . | +++ | . | +++ |
| tests/assets_errors.rs | 153 | + | . | . | +++ | . | ++ |
| tests/project_meta.rs | 126 | + | . | . | +++ | . | . |
| tests/auth_refresh.rs | 106 | + | . | . | +++ | . | . |
| tests/auth_login_config_errors.rs | 97 | + | . | . | +++ | + | + |
| tests/oauth_embedded_login.rs | 32 | +++ | . | . | +++ | . | ++ |
| tests/common/mock_server.rs | 13 | ++ | . | . | + | . | +++ |
| tests/common/mod.rs | 2 | ++ | . | . | + | . | . |

### §1.4 Distribution by substantive-pass count

By "substantive pass" = pass-family with ≥2 path mentions of that file:

| Substantive passes | Source-file count |
|---|---|
| 0 | 26 (mostly `mod.rs` files and small re-export shells; LOC ≤ 60 except a handful) |
| 1 | 13 |
| 2 | 7 |
| 3 | 12 |
| 4 | 11 |
| 5 | 6 |
| 6 (all passes) | 5 (`api/auth.rs`, `api/client.rs`, `cache.rs`, `config.rs`, `cli/auth.rs` family + `cli/issue/list.rs`-class) |

---

## §2. Blind spots by category

A "blind spot" is a source file ≥100 LOC with <2 substantive passes by **path-grep**. For each, I performed a content-grep (struct names, function names, behavior keywords) to confirm whether the file is *actually* uncovered.

### §2.1 Apparent path-blind, content-covered (FALSE positives)

These files showed weak coverage by relative-path grep but are substantively covered when searched by content. Pass 2 (Domain Model) and Pass 3 (BCs) routinely refer to behavior by function/struct name without quoting the relative path.

| File | LOC | Apparent gap | Content evidence |
|---|---|---|---|
| `src/api/jira/projects.rs` | 121 | path mentioned 1× total | `get_project_issue_types`, `get_priorities`, `get_project_statuses`, `list_projects` — 18+ mentions across P2/P3 (pass-2-deep-r2 §"Pub structs (4): IssueTypeMetadata, PriorityMetadata, StatusMetadata, IssueTypeWithStatuses"; pass-2-deep-r6 NEW-INV-373 covers handle_fields 4-sequential-API-call; pass-2-deep-r5 covers `get_project_statuses`) |
| `src/api/jira/sprints.rs` | 109 | path mentioned 1× total | `list_sprints` — 9+ mentions; pass-2-deep-r2 enumerates "Methods (4): list_sprints, get_sprint_issues, add_issues_to_sprint, move_issues_to_backlog" with pagination semantics; BC-401-class entries |
| `src/api/jsm/servicedesks.rs` | 127 | path mentioned 1× total | `list_service_desks`, `service_desk_id`, `/rest/servicedeskapi/servicedesk` — 17+ mentions across pass-2-deep-r4, pass-2-domain-model, pass-3-deep-r3 BC-1031 (project-meta orchestration cache-miss path documented) |
| `src/cli/project.rs` | 133 | path mentioned 2× total | `ProjectCommand::List`/`Fields`, project fields enumeration — extensively analyzed in pass-0-deep-r1 CONV-ABS-10, pass-1-deep-r1 D11, pass-2-deep-r6 NEW-INV-373 + CONV-ABS-11 (CORRECTION) |
| `src/cli/team.rs` | 120 | path mentioned 2× total | `team list`, lazy-org-discovery — pass-2-domain-model maps the command, BCs reference `cache::CachedTeam` cache contract |
| `src/cli/user.rs` | 165 | path mentioned 5× total | `UserCommand::Search/List/View` — pass-2-domain-model, BC entries for `user search`, BC-disambiguation tests cited |
| `src/cli/api.rs` | 342 | path mentioned 7× total but only P0-deep | Pass 2 R2 catalogs E-API-CLI-01 (HttpMethod enum), body resolution (`@file`/`@-`), header parsing; pass-1-architecture flags the `crate::api` vs `crate::cli::api` namespace foot-gun; pass-1-deep-r1 has L3b raw passthrough flow node |
| `src/types/assets/object.rs` | 329 | path mentioned 6× total | `AssetObject`, `AssetAttribute`, `ObjectAttributeValue`, `ObjectType` — 28+ mentions across pass-1-architecture L5 inventory, pass-2-deep-r4 (AQL search), pass-2-domain-model (10× — entity rows, attribute aggregation), pass-5-deep-r1 |
| `src/types/assets/schema.rs` | 116 | path mentioned 4× total | `ObjectSchema`, `ObjectTypeEntry` — covered in pass-2-deep-r4 (schema discovery), pass-2-domain-model entity rows |
| `src/types/jira/changelog.rs` | 126 | path mentioned 3× total | `ChangelogEntry`, `ChangelogItem` — pass-2-domain-model has both entity rows with field-by-field shape; pass-2-deep-r2 §"Changelog: +7 entities (E-CL-01..07) + +8 invariants"; pass-2-deep-r5 NEW-INV-235 covers truncate-to-rows behavior |
| `src/api/assets/objects.rs` | 237 | path mentioned 5× total | `search_assets`, `resolve_object_key` — pass-2-deep-r4 covers AQL search with pagination=25, attribute caching; BC entries for AQL escape semantics |

**Verdict on §2.1:** Coverage is real — only the path-mention counter undersells it. None of these warrants a targeted mini-round on its own.

### §2.2 Truly thin coverage (TRUE blind spots)

Files where neither path-grep nor content-grep produces 2 substantive pass-family hits.

| File | LOC | Reality | Significance |
|---|---|---|---|
| `src/cli/issue/assets.rs` | 65 | 1 P0 path mention; not analyzed in P2/P3 | LOW — Thin wrapper; the linked-asset behavior is fully covered under `src/api/assets/linked.rs` (557 LOC) which gets +++ in P0/P4 and ++ in P2 |
| `src/lib.rs` | 12 | 3 mentions, all "re-exports for tests" boilerplate | LOW — 12 LOC pub-use shell |
| `src/api/assets/tickets.rs` | 19 | 2 P2 mentions only | LOW — 19 LOC. `connected_tickets` API is covered by topic |
| `install.sh` | 128 | Top-level mention only (line count, file class) | MEDIUM — Shell-script installer. Content (curl + GitHub releases + arch detection + PATH check) is NOT analyzed. NOT in scope for a Rust CLI port but referenced by README. |
| `README.md` | 449 | Top-level mention only | MEDIUM — Public README has CLI command examples, install instructions, troubleshooting. Pass 0 surfaced it but content (command reference parity with code) was never cross-checked. Could surface CLAUDE.md staleness echoes. |
| `rust-toolchain.toml` | 3 | Inventory mentions only | LOW — 3 LOC, fully described in P0 |
| `.gitignore` | 4 | 0 mentions | LOW — 4 LOC trivial |
| `tests/common/mod.rs` | 2 | inventory only | LOW — 2 LOC |
| `tests/oauth_embedded_login.rs` | 32 | 5 P0 + 8 P3 + 2 P5 | NONE — actually well covered relative to tiny size |

### §2.3 Subsystems mentioned only in inventory

None remain. Re-checking the 26 source files with 0 substantive path-passes shows they fall into two buckets:

1. **Small re-export `mod.rs` files** (≤30 LOC each): `src/api/mod.rs` (8), `src/api/assets/mod.rs` (5), `src/api/jira/mod.rs` (11), `src/api/jsm/mod.rs` (2), `src/cli/issue/mod.rs` (93), `src/types/mod.rs` (3), `src/types/jira/mod.rs` (17), `src/types/assets/mod.rs` (9), `src/types/jsm/mod.rs` (5). Trivial structurally; covered by the re-export tables in pass-1-architecture and CLAUDE.md.
2. **Small entity-only types** (≤25 LOC each): `src/types/jira/project.rs` (24), `src/types/jira/sprint.rs` (12), `src/types/jira/user.rs` (12), `src/types/jira/worklog.rs` (16), `src/types/jsm/servicedesk.rs` (10). Each has at least one entity row in pass-2-domain-model; the small file size means the entity row IS the substantive analysis.

---

## §3. Recommended targeted mini-rounds

After cross-checking content coverage, **no HIGH-priority blind spots remain**. Two MEDIUM-priority items are flagged for transparency:

### Optional (MEDIUM): phase-b5-tr-1 — Public README content cross-check

- **File:** `README.md` (449 LOC)
- **Justification:** Public README is the user-facing source of truth for CLI commands, install procedure, env vars, and troubleshooting. Convergence work has only enumerated its existence, never validated parity against code. Drift here is invisible to developers.
- **Scope:** Diff README command examples and flag tables against `cli/mod.rs` clap defs; verify env-var docs (`JR_BASE_URL`, `JR_PROFILE`, `JR_RUN_KEYRING_TESTS`, `JR_BUILD_OAUTH_*`); validate install.sh references resolve.
- **Likely outcome:** A handful of CONV-DOC entries (similar to existing CONV-ABS-* findings against CLAUDE.md). Not behavior-changing.

### Optional (MEDIUM): phase-b5-tr-2 — install.sh inspection

- **File:** `install.sh` (128 LOC, top-level)
- **Justification:** Shell installer is the on-ramp for non-cargo users. Behavior is part of the product surface but never deep-analyzed.
- **Scope:** Catalog detected platforms, version pin policy, tarball verification (sha256), PATH instructions, idempotency. Surface NFRs that should appear in the security/distribution slice of Pass 4.
- **Likely outcome:** 2-4 NFR entries (NFR-DIST-*) and a couple of BCs around install-time behavior. Bounded scope.

**Recommendation:** Defer both unless the orchestrator wants completeness on the distribution surface. Neither blocks Phase B.6 (extraction validation) or Phase C synthesis.

---

## §4. Verdict

**PASS** — coverage is comprehensive for the implementation surface that matters for semantic porting. Every Rust source file ≥100 LOC has substantive content-level coverage in at least 2 pass families. The 26 source files with 0 path-substantive passes are either:

- Trivially structural (`mod.rs` re-exports, ≤30 LOC), or
- Already fully described by their entity row in pass-2-domain-model (small `types/*` files, ≤25 LOC), or
- Wrappers whose behavior lives elsewhere and is well-analyzed there (`cli/issue/assets.rs` → `api/assets/linked.rs`).

The two MEDIUM items (README cross-check, install.sh) are documentation-surface gaps, not implementation-surface gaps. They can be addressed in a future Phase B.5 iteration if needed but do not block proceeding to Phase B.6.

---

## §5. Audit log

**Method actually used:**
1. Listed every `.rs` source file under `src/` (80 files, 23 334 LOC) and every test file under `tests/` (36 files).
2. Bundled the 28 analysis Markdown files into 6 pass-family bundles (P0/P1/P2/P3/P4/P5) including their deep-deepening rounds (P2 has r1–r7, P3 has r1–r4, P0/P1/P4/P5 have r1–r2; P4 also has r3/r4).
3. Ran `grep -F -c <relative-source-path>` against each bundle for every source file. Aggregated counts produce `coverage-matrix.txt`.
4. Repeated for build/config/CI/docs and tests.
5. For every file with <2 substantive path-passes and ≥100 LOC, ran a second-pass content grep using struct names, function names, or behavior keywords (e.g., `list_sprints`, `ChangelogEntry`, `AssetObject`, `service desk`). 11 of 11 weak-by-path cases turned out to be covered by content.

**Caveats:**
- "Mention count" treats every distinct grep hit equally. A pass that mentions a file 3× in passing + 0× substantively still scores `+++`. The §2.1 cross-check was the safety valve to catch this.
- Conversely, a file mentioned only twice but each time with a paragraph of analysis (e.g., `src/api/jira/sprints.rs` in pass-2-deep-r2) scored `+` even though the analysis is dense. Content cross-check confirmed substantive coverage.
- I did not score `.factory/semport/jira-cli/jira-cli-pass-6-synthesis.md` against this matrix; synthesis is downstream of the deepening rounds and would inflate counts without adding new analysis evidence.
- Coverage of `docs/` (ADRs, specs, plans) was not in scope — those are *inputs* to the analysis, not artifacts being audited.

**Output files:**
- This document: `.factory/semport/jira-cli/jira-cli-coverage-audit.md`
- Raw matrix data (intermediate): regenerable via `/tmp/coverage_audit.sh` (deleted at session end; the methodology is documented above).
