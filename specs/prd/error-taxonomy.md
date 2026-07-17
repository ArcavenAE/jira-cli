---
context: error-taxonomy
title: "Error Taxonomy"
last_updated: 2026-07-16
source_pass: 3
trace: |
  - L2: .factory/specs/domain-spec/
  - Source broad: .factory/semport/jira-cli/jira-cli-pass-3-behavioral-contracts.md §2.X error sections
  - Source R1: .factory/semport/jira-cli/jira-cli-pass-3-deep-r1.md §3.1 (JrError variants)
  - Source P8: .factory/semport/jira-cli/jira-cli-pass-8-deep-synthesis.md §6.1 (design patterns)
  - F2 amendment (2026-07-11, issue #577 SOH-COMMENT-CRUD-1, adversary pass-44 fix round 47 F-2): Section 3 — comment 403/404 override rows added (UserError exit 64, body surfaced; BC-3.5.004/BC-3.5.005/BC-3.5.010); TD-031 pre-existing violation corrected (volatile line cite replaced with stable symbol anchor src/api/client.rs::extract_error_message); pre-existing table-cell pipe escaped in BC-CITE-001 False-positive risk row
  - F2 amendment (2026-07-16, issue #576 SOH-ATTACHMENTS-1, adversary pass-16 fix round 16 P16-001): Section 3 — attachment 404 override rows added (BC-2.7.006/BC-2.7.012/BC-3.9.008/BC-3.9.013/BC-3.9.015); first 413 surface added (attachment upload, BC-3.9.001/BC-3.9.012); perimeter-scan [process-gap] recorded in impact-boundary-576.md
---

# Error Taxonomy — jira-cli

## Section 1: JrError Variant Catalog

11 variants (corrected from Pass 1 broad's "10" at CONV-ABS §7.3). Source: `src/error.rs`.

| Variant | Exit Code | Category | Severity | When Raised |
|---|---|---|---|---|
| `NotAuthenticated` | 2 | Auth | BROKEN | 401 response from any authenticated endpoint; no token in keychain |
| `InsufficientScope` | 2 | Auth | BROKEN | 401 response with body containing `"scope does not match"` |
| `NetworkError` | 1 | Transport | BROKEN | DNS failure, TLS error, connection refused, timeout |
| `ApiError(status, msg)` | 1 | API | BROKEN | HTTP 4xx (except 401/403/429) or 5xx after retry exhaustion |
| `ConfigError(msg)` | 78 | Config | BROKEN | Malformed TOML, missing required field, migration failure |
| `UserError(msg)` | 64 | User | BROKEN | Bad flag combination, validation failure, ambiguous match |
| `Internal(msg)` | 1 | Internal | BROKEN | Unexpected code path, logic error, unwrap on None in unreachable |
| `Interrupted` | 130 | Signal | — | Ctrl+C received (tokio::select! in main.rs) |
| `Http(#[from] reqwest::Error)` | 1 | Transport | BROKEN | Low-level reqwest transport errors not covered by NetworkError |
| `Io(#[from] std::io::Error)` | 1 | IO | BROKEN | File read/write failures (config, cache) |
| `Json(#[from] serde_json::Error)` | 1 | Parse | BROKEN | Response body deserialization failure |

### Exit Code Semantics

| Exit Code | Meaning | JrError Variants |
|---|---|---|
| 0 | Success | (no error) |
| 1 | Runtime error (API, network, IO, internal) | `NetworkError`, `ApiError`, `Internal`, `Http`, `Io`, `Json` |
| 2 | Authentication error | `NotAuthenticated`, `InsufficientScope` |
| 64 | User error (bad input, validation failure) | `UserError` |
| 78 | Configuration error | `ConfigError` |
| 130 | Interrupted (Ctrl+C) | `Interrupted` |

### JSON Error Shape (--output json)

When `--output json` is active AND a `JrError` is raised, output goes to **stderr** as:

```json
{"error": "<human message>", "code": <exit_code>}
```

- `error`: same message as human-readable stderr would show
- `code`: integer exit code per table above
- Output channel: stderr (NOT stdout; stdout reserved for data)

---

## Section 2: `extract_error_message` 7-Step Precedence Chain

Source: `src/api/client.rs::extract_error_message`. Corrected from broad pass per CONV-ABS-004; further corrected per ADV-P2-001 (empty body returns literal string, not None; no nested messages[] level; no errorDescription).

| Priority | Condition | Behavior |
|---|---|---|
| 1 (HIGHEST) | Response body byte length == 0 | Return literal string `"<empty response body>"` (early return; no UTF-8 or JSON parsing) |
| 2 | Body bytes are non-UTF-8 | Return `String::from_utf8_lossy(body)` with Unicode replacement chars (early return) |
| 3 | Body is JSON with `errorMessages` array having ≥1 string element | Return elements joined with `"; "` |
| 4 | Body is JSON with non-empty `errors` object | Return `"field: value"` pairs alphabetically sorted, joined with `"; "`; non-string values use `serde_json::Value` display |
| 5 | Body is JSON with top-level `message` string field | Return the string value as-is |
| 6 | Body is JSON with top-level `errorMessage` string field (JSM endpoints) | Return the string value as-is |
| 7 (FALLBACK) | Body is non-JSON OR JSON with no recognized fields matched above | Return raw body string (valid UTF-8 already confirmed at step 2) |

**Key invariants**:
- Step 1 returns a STRING (not None). The string `"<empty response body>"` propagates into `JrError::ApiError { message }`. There is no status-code-derived substitution.
- The function doc comment inside client.rs lists a different order ("1. errorMessages … 5. Empty body") — that comment is STALE. Code execution order above is authoritative.
- `errors.field.messages[]` (nested messages array) is NOT a recognized level. Non-string error values are rendered via `serde_json::Value::to_string()` (curly-brace JSON).
- `errorDescription` is NOT a recognized field. Only `errorMessage` (singular) is supported.

---

## Section 3: Per-Status-Code Error Mapping

### 4xx Responses

| HTTP Status | JrError Variant | Exit Code | Message Pattern |
|---|---|---|---|
| 400 | `ApiError(400, extracted_msg)` | 1 | Extracted message or `"Bad request"` |
| 400 with `resolution` field | `UserError(...)` | 64 | `"Field 'resolution' is required"` → hint: `--resolution`, `jr issue resolutions` |
| 401 (general) | `NotAuthenticated` | 2 | `"Not authenticated. Run: jr auth login"` |
| 401 with scope mismatch | `InsufficientScope` | 2 | `"Insufficient token scope. <details>. Run: jr auth login"` |
| 403 | `ApiError(403, ...)` | 1 | `"Forbidden"` or extracted body message |
| 403 — `comment delete/edit/view` | `UserError(...)` | 64 | `"comment not found or permission denied: <KEY>#<ID>"` + Jira body on separate line (BC-3.5.004/BC-3.5.005/BC-3.5.010 override) |
| 403 — `attachment list` | `ApiError(403, ...)` | 1 | `"Permission denied: cannot access issue <KEY>."` (canonical string only; Jira body NOT surfaced; BC-2.7.006) |
| 403 — `attachment download` (issue GET or AID metadata-GET) | `ApiError(403, ...)` | 1 | `"Permission denied: cannot access issue <KEY>."` (issue 403) or `"Permission denied: cannot access attachment <AID>."` (AID 403); canonical string only; Jira body NOT surfaced (issue-GET sub-variant: BC-2.7.012 batch paths only; AID metadata-GET sub-variant: BC-2.7.012 / EC-2.7.007-1b) |
| 403 — `attachment delete` pre-prompt metadata-GET | `ApiError(403, ...)` | 1 | `"Permission denied: cannot access attachment <AID>."` (canonical string only; Jira body NOT surfaced — read GET, not write; BC-3.9.015) |
| 404 | `ApiError(404, ...)` | 1 | `"Not found: <resource>"` |
| 404 — `comment delete/edit/view` | `UserError(...)` | 64 | `"comment not found or permission denied: <KEY>#<ID>"` + Jira body on separate line (BC-3.5.004/BC-3.5.005/BC-3.5.010 override) |
| 404 — `attachment list` (issue KEY) | `UserError(...)` | 64 | `"Issue <KEY> not found or not accessible."` (canonical string only; Jira body NOT surfaced; BC-2.7.006) |
| 404 — `attachment download` (KEY or AID) | `UserError(...)` | 64 | `"Issue <KEY> not found or not accessible."` or `"Attachment <AID> not found or not accessible."` (canonical string only; Jira body NOT surfaced — read-path convention; BC-2.7.012 / EC-2.7.007-1) |
| 404 — `attachment delete` (single AID, DELETE or pre-prompt metadata-GET) | `UserError(...)` | 64 | DELETE 404: canonical string + Jira body surfaced (DEC-168; BC-3.9.008/BC-3.9.013). Pre-prompt metadata-GET 404: canonical string only, no body (BC-3.9.015 — read GET, not write). Multi/bulk/`--replace-existing` 404 = benign-skip exception, NOT exit 64 (BC-3.9.013) |
| 413 — `attachment upload` | `ApiError(413, ...)` | 1 | `"Attachment too large: the file exceeds the server-configured limit."` (no numeric limit stated; first 413 surface in the product; BC-3.9.001/BC-3.9.012) |
| 409 | `ApiError(409, ...)` | 1 | Extracted message |
| 422 | `ApiError(422, ...)` | 1 | Extracted message |
| 429 | Retry (up to MAX_RETRIES=3) | — | Final retry → return 429 response to caller (NOT error for `send_raw`) |

### 5xx Responses

| HTTP Status | JrError Variant | Exit Code | Message Pattern |
|---|---|---|---|
| 500 | `ApiError(500, ...)` | 1 | `"API error (500)"` |
| 502 | `ApiError(502, ...)` | 1 | `"API error (502)"` |
| 503 | `ApiError(503, ...)` | 1 | `"API error (503)"` |
| 5xx (after MAX_RETRIES=3) | `ApiError(status, ...)` | 1 | `"API error (<status>)"` |

---

## Section 4: Remediation Conventions

Every error message must suggest a next action. Conventions by category:

| Category | Suggestion Template |
|---|---|
| NotAuthenticated | `"Run: jr auth login"` or `"Run: jr auth refresh"` |
| InsufficientScope | `"Re-authenticate with required scopes. See: github.com/Zious11/jira-cli/issues/185"` |
| NetworkError | `"Could not reach <host>. Check your network connection."` |
| ApiError (generic) | `"API error (<status>). Check jr auth status."` |
| ConfigError | `"Configuration error: <details>. Check ~/.config/jr/config.toml"` |
| UserError (ambiguous) | `"Ambiguous <thing>: <candidates>"` + list of candidates |
| UserError (validation) | `"Invalid <thing>: <details>"` + valid format hint |

---

## Section 5: `partial_match` Error Semantics

`MatchResult` is a 4-state enum used by status disambiguation, user lookup, and asset status filtering:

| MatchResult variant | When | Error behavior |
|---|---|---|
| `Exact` | Exactly one exact case-insensitive match | No error — use the match |
| `ExactMultiple` | Multiple exact-case matches (same string, different case) | No error — use any (or first) |
| `Ambiguous` | Single substring match overlaps multiple candidates | `UserError` (exit 64) + list all candidates |
| `None` | Zero matches | `UserError` (exit 64) + "not found" |

**Invariant**: Single-substring match is always `Ambiguous` regardless of match count. This is fail-closed design — `partial_match` never silently auto-selects when multiple candidates share a substring.

---

## Section 6: Domain-Specific Error Messages

### Sprint Commands

| Condition | Error | Exit Code |
|---|---|---|
| `sprint list`/`sprint current` on kanban board | `"Sprint commands are only available for scrum boards"` | 1 |
| `sprint add --sprint` + `--current` together | clap error (mutual exclusion) | non-zero |
| `sprint add` with no `--sprint` or `--current` | clap error (required one-of) | non-zero |

### Asset Commands

| Condition | Error | Exit Code |
|---|---|---|
| `validate_asset_key` invalid format | `"Invalid asset key: <key>. Expected: PREFIX-NNN"` | 64 |
| `assets tickets --status <SUBSTR>` ambiguous | `"Ambiguous status: <candidates>"` | 64 |
| `assets schema <TYPE-SUBSTR>` ambiguous | `"Ambiguous type: <candidates>"` | 64 |
| `assets tickets --open` + `--status` together | clap error (mutual exclusion) | non-zero |

### Auth Commands

| Condition | Error | Exit Code |
|---|---|---|
| `auth remove <active-profile>` | `"cannot remove active profile"` | 64 |
| `auth refresh` with unconfigured profile + `--no-input` | `"no URL configured. Run: jr auth login --url <URL>"` | 64 |
| Invalid profile name | `"Invalid profile name: <name>"` | 64 |
| Config TOML parse failure | `"Failed to parse config: <toml error>"` | 78 |

### Config / Profile

| Condition | Error | Exit Code |
|---|---|---|
| Profile not found in config | `"Profile '<name>' not found. Run: jr auth login"` | 64 |
| `JR_PROFILE` set to nonexistent profile | same as above | 64 |
| Multi-profile fields bug (NFR-R-D, MUST-FIX) | After fix: error message must reference `[profiles.<name>]` not deprecated `[fields]` | 64 |

---

## Section 7: `send` vs `send_raw` Error Contract

Two HTTP dispatch paths with different error semantics:

| Path | Auth injection | Error on 4xx/5xx | 429 handling | Used by |
|---|---|---|---|---|
| `send(req)` | Yes — injects `Authorization` header on every retry | Raises `JrError` | Retries up to MAX_RETRIES=3 | `get`, `post`, `put`, `delete`, `post_no_content`, `get_from_instance`, `post_to_instance`, `get_assets`, `post_assets` |
| `send_raw(req)` | Via `request()` (caller calls `client.request()` to build, auth injected there) | Returns `reqwest::Response` to caller — no error | Retries up to MAX_RETRIES=3 THEN returns 429 response | `jr api` raw passthrough |

**Key invariant**: `send_raw` never raises `JrError` for 429 — the raw status code is returned to caller. This is intentional for the `jr api` passthrough command.

---

## Section 8: CI Guard Failure Taxonomy (DEAD-CITATION-CI F2 2026-06-19)

### CI-CITE-001: CLAUDE.md dead path citation

| Field | Value |
|---|---|
| **Guard** | `tests/claude_md_citations.rs::test_claude_md_citations_resolve_to_real_files` |
| **Category** | Doc-fallout / citation drift |
| **Severity** | BROKEN (test fail — blocks CI) |
| **Exit code** | Rust test failure (non-zero `cargo test` exit) |
| **When raised** | One or more backtick-quoted path tokens in CLAUDE.md match the in-scope grammar (known directory prefix OR ROOT_FILES exact-match, plus recognized extension) but do NOT resolve to a real file at `Path::new(CARGO_MANIFEST_DIR).join(&citation)` |
| **Message format** | Lead line: `CLAUDE.md cites file paths that do not exist on disk:` — then one `  <path> (line {n})` per dead reference where `{n}` is the real 1-based line number in CLAUDE.md (e.g. `  src/foo.rs (line 142)`) — then `Fix the citation or restore the file.` — then `Note: .factory/, glob, and symbol-form tokens are auto-excluded. Root-level files (Cargo.toml, CLAUDE.md, etc.) are checked.` |
| **Actionability** | Each dead citation is listed on its own line, prefixed with two spaces, followed by ` (line {n})` where `{n}` is the actual 1-based line number of the citation in CLAUDE.md. Line numbers are computed from the `(path, line)` pairs returned by `extract_path_citations(doc: &str) -> Vec<(String, usize)>` filtered by `!Path::exists()`. The developer can: (a) open CLAUDE.md at line `{n}`, (b) restore the deleted/renamed file, or (c) update the citation to the new path. There is NO allowlist — `.factory/` paths are always excluded by the dir-prefix filter; `.factory/` citations never trigger this error. Bare-filename shorthands (e.g., `ci.yml`, `adf.rs`) that are not in ROOT_FILES also never trigger this error. |
| **False-positive risk** | LOW when the guard is correctly implemented per BC-X.13.002 (glob/brace-glob skip, suffix strip, trailing-punct trim, dir-prefix filter + ROOT_FILES inclusion with curated exact-match set) and BC-X.13.003 (all `.factory/` excluded via dir-prefix filter). A false positive means a token was incorrectly classified as in-scope; the fix is a ROOT_FILES exclusion or suffix-strip update in `extract_path_citations`. |
| **Tracing BCs** | BC-X.13.001 (core path-existence, canonical failure message), BC-X.13.002 (normalization pipeline), BC-X.13.003 (ALL `.factory/` excluded via dir-prefix filter) |

### BC-CITE-001: bc-*.md Trace/Source dead file or symbol citation

[Added 2026-07-05 CITATION-GUARDS Story B S-BC-CITATION-GUARD-1 issue #102]

| Field | Value |
|---|---|
| **Guard** | `scripts/check-bc-citation-symbols.sh::run_check` |
| **Category** | Doc-fallout / citation drift |
| **Severity** | BROKEN (guard exit 1 — blocks spec-guard CI job) |
| **Exit code** | 1 (bash script exit code; blocks spec-guard job in CI gate) |
| **When raised** | One or more backtick-quoted `src/` citation tokens in a `**Trace**:` or `**Source**:` field of any bc-*.md file: (a) reference a file that does not exist under the develop checkout `src/` tree (applies to both tier (i) `.rs` and tier (ii) non-`.rs` tokens per BC-X.13.005 Step 3b); OR (b) contain a `::symbol` suffix whose symbol definition is absent in the referenced file (tier (i) `.rs` tokens only; import-only occurrences are DEAD — the DEC-148 class); OR (c) the total citation count in CANONICAL_MODE falls below `FLOOR = floor(0.75 × N)` ≈ 231 (extraction-dropout guard; F-01 two-tier recalibration: N=309, FLOOR=231 on 2b09313; pre-two-tier post-Task-0-hygiene census: N=331, FLOOR=248; pre-hygiene DEC-154 values: N=326, FLOOR=244) |
| **Message format** | One or more of: `DEAD: <file> not found` (file absent on disk); `DEAD: <symbol> not found in <file>` (symbol definition absent in file; import-only does NOT count); `DEAD: malformed citation skipped: <token>` (path shape guard rejected token — contains `..` or non-allowed characters); `BC-CITE-COVERAGE-FLOOR: expected >= <FLOOR> src/ citations, got <N>. Update FLOOR when citations are intentionally removed (the floor is a lower bound; additions never fire it).` (CANONICAL_MODE floor guard only); Summary line: `<K> stale citation(s) found in bc-*.md Trace/Source fields` |
| **Actionability** | (a) Dead-file: update the `**Trace**:` or `**Source**:` field in the bc-*.md body to cite the new file path after a rename or Seam extraction (ADR-0012 class), or restore the file. (b) Dead-symbol: update the citation to the new function/symbol name and/or new file path where it now lives. (c) Floor fired: if citations were legitimately reduced below FLOOR (e.g., large BC refactor), update the script-scope `FLOOR=N` assignment at the top of `scripts/check-bc-citation-symbols.sh` (the single recalibration touchpoint — it is NOT a `local` variable inside `run_check`) to the new measured baseline (run `bash scripts/check-bc-citation-symbols.sh` in canonical mode to measure N), and commit in the same PR as the BC edit. Run `bash scripts/check-bc-citation-symbols.sh --self-test` locally to confirm all 10 fixtures still pass. |
| **False-positive risk** | LOW. The fn-anchored grep uses `([^[:alnum:]_]\|$)` word-boundary suffix preventing partial-name false-greens. Glob tokens (path contains `*`) are silently skipped, not DEAD-flagged. The FLOOR is calibrated at floor(0.75 × N) giving ~25% legitimate-churn headroom. DEC-154 Option A extends grammar with 3 branches (::tests, ::tests::testfn, standalone CamelCase) eliminating the class-8/9/10 grammar gaps. |
| **Tracing BCs** | BC-X.13.004 (file-existence + SCOPE-EMPTY guard + coverage floor), BC-X.13.005 (extraction grammar + definition-anchored symbol check + v1-pragmatic shape-split + DEC-154 3 new branches), BC-X.13.006 (scope + CI topology + 10-fixture self-test) |
