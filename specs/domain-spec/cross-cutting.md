---
title: "Cross-Cutting Utilities"
version: "1.0.0"
snapshot_sha: "dea166471e22eff55974d7675593469b37048c5f"
traces_to: "README.md"
source_passes: "Pass 2 broad §2a.3 + §2a.4 + Pass 8 §6 Conventions"
entity_count: 12
invariant_count: 18
---

# Cross-Cutting Utilities

These modules are consumed by multiple bounded contexts and carry domain-meaningful invariants that do not belong to any single context. They form Layer 6 of the 5+1 layer architecture (see Pass 8 §2.3).

Modules: `jql.rs`, `duration.rs`, `partial_match.rs`, `observability.rs`, `api/client.rs`, `api/pagination.rs`, `api/rate_limit.rs`.

---

## §1 Modules & Entities

| Module | LOC | Purpose |
|--------|----:|---------|
| `jql.rs` | 395 | JQL/AQL escaping, validation, asset clause building |
| `duration.rs` | 159 | Worklog duration parser/formatter |
| `partial_match.rs` | 200 | Case-insensitive substring matching with disambiguation |
| `observability.rs` | 39 | Once-per-process verbose log helper |
| `api/client.rs` | 490 | `JiraClient` HTTP methods, auth headers, rate-limit retry |
| `api/pagination.rs` | 374 | 4 pagination shapes |
| `api/rate_limit.rs` | 56 | Retry-After integer parser |

---

## §2 JQL Utilities (`jql.rs`)

### Entities / Value Objects

- **`escape_value(s: &str) -> String`**: escapes backslashes first, then double-quotes. Order is load-bearing — reversing allows escape-neutralization. Property-tested by `escaped_value_never_has_unescaped_quote`.
- **`validate_duration(s: &str) -> Result<()>`**: accepts `<digits><single-unit>` where unit ∈ `{y,M,w,d,h,m}`. Case-sensitive (`M`=months, `m`=minutes). Combined units (`4w2d`) rejected. Reversed order (`d7`) rejected.
- **`validate_date(s: &str) -> Result<()>`**: ISO-8601 `YYYY-MM-DD` only. Leap-day handling delegated to `chrono::NaiveDate`.
- **`validate_asset_key(s: &str) -> Result<()>`**: `<alphanumeric>-<digits>`. Prefix must be ASCII alphanumeric and non-empty. Number must be ASCII digits and non-empty.
- **`build_asset_clause(asset_key: &str, cmdb_fields: &[(String, String)]) -> String`**: produces `"<field_name>" IN aqlFunction("Key = \"<asset_key>\"")` for one field, or parenthesized OR-join for multiple. Uses field NAME (not ID). Runs `escape_value` on both field name and asset key.

### Invariants

| ID | Invariant | Source |
|----|----------|--------|
| INV-JQL-001 | `escape_value` escapes backslashes FIRST, then double-quotes. Reversing the order creates exploitable escape-neutralization. Property-tested. | `jql.rs:6-8`, `jql.rs:383-394` |
| INV-JQL-002 | `validate_duration` and `duration::parse_duration` have DIFFERENT syntaxes. JQL duration: single-unit only (`4w` ok, `4w2d` rejected). Worklog duration: combined units ok (`1w2d3h30m`). Same-looking inputs can pass one and fail the other. | `jql.rs:16-33`, `duration.rs:5-49` |
| INV-JQL-003 | `validate_duration` unit charset is case-sensitive: `M` = months, `m` = minutes. A JQL user intending "minutes" who types `5M` gets "5 months". | `jql.rs:16-33` |
| INV-JQL-004 | `build_asset_clause` uses field NAME (not `cf[ID]` or `customfield_NNNNN`) in `aqlFunction()`. The `(id, name)` tuple `id` is destructured-and-ignored. | `jql.rs:67-74`, BC-308 |
| INV-JQL-005 | AQL attribute for asset object key is `Key` (capital K, NOT `objectKey`). Hardcoded literal in `jql.rs:70`. | `jql.rs:70`, BC-309 |
| INV-JQL-006 | Absolute dates are `YYYY-MM-DD` only. Feb-30 and Feb-29 in non-leap years are rejected by `chrono`. | `jql.rs:88-92` |

---

## §3 Duration Parser (`duration.rs`)

### Entities / Value Objects

- **`parse_duration_validate(input: &str) -> Result<(), JrError>`**: production path (S-2.06 v2.0.0). Accepts combined units `1w2d3h30m`, also accepts space-separated `2d 3h 30m`. No arithmetic performed — syntactic validation only. Case-insensitive. Units: `w`/`d`/`h`/`m` only.
- **`format_duration(seconds: u64) -> String`**: inverse. Returns `"30m"`, `"2h"`, or `"1h30m"` only — never weeks/days (format collapses to hours+minutes).

Note: the 3-arg `parse_duration(input, hours_per_day, days_per_week) -> Result<u64>` calculator was deleted in S-3.10. It had no production caller after S-2.06 v2.0.0 (when `worklog add` switched to server-side `timeSpent` passthrough) and was retained only for the `format_duration` round-trip proptest. That proptest has been rewritten in S-3.10 to use `format_duration` directly without the calculator.

### Invariants

| ID | Invariant | Source |
|----|----------|--------|
| INV-DUR-001 | ~~`parse_duration` accepts combined units (`1w2d3h30m`), unlike `validate_duration` which rejects them.~~ **DELETED S-3.10**: `parse_duration` calculator removed. `parse_duration_validate` (production path) accepts combined units; `validate_duration` (JQL) rejects them. This syntax divergence between the two surviving functions remains invariant. | `duration.rs`, `jql.rs:16-33` |
| INV-DUR-002 | ~~`parse_duration` is case-insensitive (input lowercased). `validate_duration` is case-sensitive.~~ **DELETED S-3.10**: `parse_duration` calculator removed. `parse_duration_validate` is case-insensitive; `validate_duration` is case-sensitive. A JQL validation pass does NOT imply worklog duration validity and vice versa. | `duration.rs`, `jql.rs:16-33` |
| INV-DUR-003 | ~~`parse_duration` u64 overflow potential for pathological inputs.~~ **DELETED S-3.10**: `parse_duration` calculator removed; overflow risk eliminated. | — |
| INV-DUR-004 | `format_duration` never returns weeks or days — always collapses to hours+minutes. Round-trip is NOT identity for week/day inputs. Property-tested for never-panics and round-trip consistency. | `duration.rs` |

---

## §4 Partial Match (`partial_match.rs`)

### Entities / Value Objects

- **`MatchResult`** (enum):
  - `Exact(String)`: one exact (case-insensitive) match.
  - `ExactMultiple(String)`: multiple exact matches (same lowercased string matches multiple items — e.g., duplicate names). Auto-resolves (takes first).
  - `Ambiguous(Vec<String>)`: one substring match, OR multiple distinct substring matches. Callers MUST prompt (TTY) or error (`--no-input`).
  - `None(Vec<String>)`: no match. Carries candidates for error message.
- **`partial_match(needle: &str, haystack: &[String]) -> MatchResult`**: entry point.

### Invariants

| ID | Invariant | Source |
|----|----------|--------|
| INV-PM-001 | Single-substring hit routes through `Ambiguous`, NOT `Exact`. Callers must not silently promote substring hits to success. Convention comment in `workflow.rs` pin. | `partial_match.rs:39-42`, Pass 2 INV-2 |
| INV-PM-002 | `Ambiguous` means "needs disambiguation" regardless of how many candidates. Whether there is 1 or N substring matches, the caller must handle disambiguation. | `partial_match.rs`, tests |
| INV-PM-003 | Resolution resolver (`workflow.rs:65-79`) never auto-promotes `Ambiguous`. This is an explicit cross-context convention shared by all name-resolution sites. | `workflow.rs:65-79`, Pass 2 INV-10 |
| INV-PM-004 | `partial_match` is used by: transition name, status name, link type name, user name, board name, queue name, resolution name, object type name. Universal name-resolution primitive. | Multiple CLI handlers |

---

## §5 HTTP Client (`api/client.rs`)

### Entities / Value Objects

- **`JiraClient`**: single struct with 11 public HTTP methods. Two paths:
  - **Validated** (9 methods): `send → parse_error → JrError`. Used by all resource impls.
  - **Raw passthrough** (2 methods): `send_raw → reqwest::Response`. Used ONLY by `jr api`.
- **`MAX_RETRIES = 3`**, **`DEFAULT_RETRY_SECS = 1`**: rate-limit retry constants.
- **`base_url()`**: returns the API endpoint (may be `api.atlassian.com/ex/jira/<cloudId>` for OAuth).
- **`instance_url()`**: returns the human-facing Jira instance URL (e.g., `myorg.atlassian.net`). Used for browsing. NFR-R-B: `handle_open` uses `base_url()` when it should use `instance_url()`.

### Invariants

| ID | Invariant | Source |
|----|----------|--------|
| INV-HTTP-001 | 401 + `"scope does not match"` (case-insensitive) → `InsufficientScope`. Status gate: 403 + same string → NOT `InsufficientScope`. | `api/client.rs`, BC-1085..1088 |
| INV-HTTP-002 | `send` retries 429 up to MAX_RETRIES=3. After exhaustion: always-stderr warning. `send_raw` also retries 429 but delivers the final 429 response to caller (NOT as `Err`). | BC-1083,1092 |
| INV-HTTP-003 | `JR_AUTH_HEADER` env var is honored in production binary (no `#[cfg(test)]` gate). NFR-S-B (HIGH). | `api/client.rs:64-66` |
| INV-HTTP-004 | `JR_BASE_URL` completely overrides the profile URL. Paired with `JR_AUTH_HEADER` for integration tests. Both env vars are test seams with no compile-time gate. | `client.rs:37-65`, CLAUDE.md |

---

## §6 Pagination (`api/pagination.rs`)

Four pagination shapes corresponding to four API style families:

| Shape | Used by | Key fields |
|-------|---------|-----------|
| `OffsetPage<T>` | Most Jira REST endpoints | `max_results`, `start_at`, `total`, `values: Vec<T>` |
| `CursorPage<T>` | JQL search (`POST /search/jql`) | `values: Vec<T>`, `nextPageToken: Option<String>` |
| `ServiceDeskPage<T>` | JSM endpoints | `_links`, `values: Vec<T>` |
| `AssetsPage<T>` | Assets AQL search | `values: Vec<T>`, `isLast: bool_or_string` (custom deserializer) |

**`DEFAULT_LIMIT = 30`** (`cli/mod.rs:740`): default page size for all list operations. Controls `resolve_effective_limit`.

---

## §7 Observability (`observability.rs`)

- **`log_parse_failure_once(flag: &AtomicBool, site: &str, iso: &str, verbose: bool)`**: fires at most one line per call-site per process. The `flag` is a caller-supplied `&AtomicBool` (each call-site has its own).
- The project has NO tracing/log crate. `--verbose`-gated `eprintln!` is the established pattern (documented in source: "Intentionally tiny").
- `observability.rs` is `pub(crate)` only.
