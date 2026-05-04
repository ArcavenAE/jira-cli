---
title: "L2 Domain Specification — jira-cli (jr)"
version: "1.0.0"
snapshot_sha: "dea166471e22eff55974d7675593469b37048c5f"
product_version: "v0.5.0-dev.7"
generated: "2026-05-04"
source_passes: "Pass 2 broad + R1-R7 deepening + Pass 8 synthesis"
phase: "Phase 1 Burst 1 (spec crystallization)"
status: "draft"
---

# L2 Domain Specification — jira-cli (jr)

This is the sharded L2 Domain Specification for `jr` (package `jr`, binary `jr`), a Rust CLI for automating
Atlassian Jira Cloud workflows. Produced from brownfield Phase 1 spec crystallization over Pass 2 domain-model
analysis (7 deepening rounds) and Pass 8 final synthesis.

**This spec is DESCRIPTIVE of what exists in v0.5.0-dev.7. It does NOT propose changes. Phase 1 product-owner
will write the L3 PRD (Burst 2) against this spec.**

---

## Document Map

| File | Bounded Context | Entities | Invariants |
|------|----------------|----------|------------|
| [bc-01-auth-identity.md](bc-01-auth-identity.md) | Auth & Identity | 14 | 22 |
| [bc-02-issue-read.md](bc-02-issue-read.md) | Issue Read (list/view/comments/changelog) | 32 | 28 |
| [bc-03-issue-write.md](bc-03-issue-write.md) | Issue Write (create/edit/move/assign/comment/link) | 18 | 24 |
| [bc-04-assets-cmdb.md](bc-04-assets-cmdb.md) | Assets & CMDB | 18 | 18 |
| [bc-05-boards-sprints.md](bc-05-boards-sprints.md) | Boards & Sprints | 14 | 14 |
| [bc-06-config-cache.md](bc-06-config-cache.md) | Configuration & Cache | 22 | 26 |
| [bc-07-output-render.md](bc-07-output-render.md) | Output Rendering & Error | 16 | 18 |
| [cross-cutting.md](cross-cutting.md) | Cross-cutting utilities | 12 | 18 |
| [state-machines.md](state-machines.md) | 5 state machines | — | — |

**Total entities:** ~146 (across 7 BCs + cross-cutting; reconciles to Pass 2 catalog of ~78 row-level entities + value objects + enums + cross-cutting utilities)

**Total invariants in BC files:** ~168 (out of 411 total; remainder covered by state machines, cross-cutting, and NFR catalog which is product-owner scope)

---

## Ubiquitous Language Glossary

Terms used system-wide; context-specific terms are defined in each BC file.

| Term | Definition |
|------|-----------|
| **jr** | The binary name. Package name is also `jr`. Never "jira-cli" in user-facing text. |
| **Profile** | A named credential context `[profiles.<name>]` in `~/.config/jr/config.toml`. Each profile maps to one Jira Cloud instance and its associated credentials. The active profile is resolved at startup via flag > env > config > `"default"`. |
| **Active profile** | The profile resolved for the current invocation. Every handler that touches the network has one. |
| **Cloud ID** | The UUID identifying a Jira Cloud instance (`cloudId`). Required for OAuth API calls routed through `api.atlassian.com`. |
| **Org ID** | The UUID identifying an Atlassian organization (`orgId`). Required for team list discovery via GraphQL. |
| **Embedded OAuth app** | The `jr`-owned Atlassian OAuth app whose credentials are XOR-obfuscated into official release binaries at build time (ADR-0006). |
| **BYO OAuth app** | A user-supplied Atlassian OAuth app (via `--client-id`/`--client-secret` flags, `JR_OAUTH_CLIENT_ID`/`JR_OAUTH_CLIENT_SECRET` env vars, or keychain). |
| **Keychain** | The OS credential store (macOS Keychain, Linux Secret Service, Windows Credential Manager) accessed via the `keyring` crate, service name `jr-jira-cli` (or `JR_SERVICE_NAME` override). |
| **JQL** | Jira Query Language. Used for issue searches. `jr` composes JQL from user flags and appends ORDER BY. |
| **AQL** | Assets Query Language. Used for Assets/CMDB object searches. Distinct from JQL. |
| **CMDB** | Configuration Management Database (Jira Assets). Custom fields on issues can reference CMDB objects. |
| **Cache** | Per-profile JSON files under `~/.cache/jr/v1/<profile>/`. 7-day TTL on all entries. |
| **Workspace ID** | The UUID for an Assets/CMDB workspace. Discovered via JSM REST and cached. |
| **issue key** | A bare `String` of the form `[A-Za-z0-9]+-\d+` (e.g., `ENG-123`). Not type-validated at the struct level. |
| **asset key** | A validated string of the form `<alphanumeric>-<digits>` (e.g., `CUST-5`). Validated by `jql::validate_asset_key`. |
| **partial_match** | The system-wide name-resolution algorithm: finds exact, substring-only (`Ambiguous`), or no match. Single-substring NEVER auto-resolves to `Exact`. |
| **`--no-input`** | Flag (auto-set when stdin is not a TTY) that disables all interactive prompts. Every command must have fully non-interactive flag equivalents. |
| **Idempotent** | State-changing commands (`issue move`, `issue assign`) exit 0 with no HTTP write when already in the target state. |
| **`DEFAULT_LIMIT`** | `30` — the default page size for list operations. |
| **`statusCategory != Done`** | The canonical JQL predicate for "open issues". Uses category key, not status name, to be instance-agnostic. |
| **Thin client** | ADR-0001 decision: `JiraClient` wraps reqwest directly. No generated client, no intermediate abstraction. |
| **Per-profile cache boundary** | Every cache read/write function takes `profile: &str` as its first argument. Enforced by convention, not the type system (NEW-INV-08). |

---

## Architectural Authorities (ADRs)

All six ADRs are authoritative. In any conflict between code, CLAUDE.md, or this spec, the ADRs govern for the concerns they cover.

| ADR | Title | Status | What it governs |
|-----|-------|--------|----------------|
| ADR-0001 | Thin client architecture | Accepted | `JiraClient` design; no generated client; manual endpoint additions |
| ADR-0002 | OAuth with embedded secret | **Superseded** by ADR-0006 | Historical only; see ADR-0006 |
| ADR-0003 | reqwest with rustls-tls | Accepted | TLS backend; no native-tls; no system OpenSSL dependency |
| ADR-0004 | Per-feature specs | Accepted | `docs/specs/` structure; CLAUDE.md as living index |
| ADR-0005 | GraphQL org discovery | Accepted | `tenantContexts` GraphQL for `orgId`/`cloudId`; single-call pattern |
| ADR-0006 | Embedded `jr` OAuth app | Accepted | XOR-obfuscated compile-time secrets; fixed port 53682; BYO escape hatch |

---

## Source-to-File Traceability

| Pass 2 source | Primary BC file(s) |
|---------------|-------------------|
| `types/jira/issue.rs`, `api/jira/issues.rs`, `cli/issue/list.rs`, `cli/issue/view.rs`, `cli/issue/comments.rs` | bc-02-issue-read.md |
| `cli/issue/create.rs`, `cli/issue/workflow.rs`, `cli/issue/links.rs`, `cli/issue/helpers.rs` | bc-03-issue-write.md |
| `api/auth.rs`, `api/auth_embedded.rs`, `cli/auth.rs` | bc-01-auth-identity.md |
| `api/assets/`, `types/assets/`, `cli/assets.rs`, `cli/issue/assets.rs` | bc-04-assets-cmdb.md |
| `cli/board.rs`, `cli/sprint.rs`, `api/jira/boards.rs`, `api/jira/sprints.rs` | bc-05-boards-sprints.md |
| `config.rs`, `cache.rs` | bc-06-config-cache.md |
| `output.rs`, `adf.rs`, `error.rs`, `cli/issue/format.rs`, `cli/issue/json_output.rs` | bc-07-output-render.md |
| `jql.rs`, `duration.rs`, `partial_match.rs`, `observability.rs`, `api/client.rs`, `api/pagination.rs`, `api/rate_limit.rs` | cross-cutting.md |

---

## MUST-FIX Bug Register (from Pass 8 synthesis)

These four correctness bugs are documented here for product-owner L3 visibility. They are DESCRIPTIVE of the current state.

| ID | Severity | Site | Summary |
|----|----------|------|---------|
| NFR-R-D | CRITICAL | `config.global.fields.*` (12+ sites) | Multi-profile fields silent regression: per-profile `story_points_field_id`/`team_field_id` ignored; always reads global `[fields]` block |
| NFR-R-B | HIGH | `cli/issue/workflow.rs:636` | `handle_open` uses `client.base_url()` instead of `client.instance_url()` — broken for OAuth profiles |
| NFR-R-A | HIGH | `api/jira/worklogs.rs:25-30` | `list_worklogs` non-paginated; silently truncates at first page for issues with >50 worklogs |
| NFR-R-E | HIGH | `cli/issue/list.rs:440,446,449,456` | Multi-workspace asset HashMap mis-attribution: `resolved` keyed by `oid` alone, drops workspace qualifier |
