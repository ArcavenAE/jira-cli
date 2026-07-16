# F1 Impact Boundary: `jr issue attachment` subcommand tree (issues #576 + #585)

- **Date:** 2026-07-15
- **Feature cycle:** SOH-ATTACHMENTS-1
- **GitHub issues:** #576 (attachment list/download/upload/delete), #585 (contentUrl in metadata — folds into Story 1)
- **Research basis:** issue bodies read via `gh issue view`; live codebase scan 2026-07-15

---

## 1. Affected component map

### Classification legend

| Label | Meaning |
|-------|---------|
| NEW | File does not exist; must be created from scratch |
| TOUCHED-DISPATCH | Existing file touched only to wire in the new subcommand (≤ ~20 LOC) |
| TOUCHED-CARGO | Cargo.toml feature addition (one line) |
| NOT AFFECTED | File confirmed not needed |

---

### 1.1 New files (epicenter)

#### `src/types/jira/attachment.rs` — **NEW**

Serde struct for Jira attachment metadata. Jira's `/rest/api/3/issue/{key}?fields=attachment` returns an array of objects with at minimum:

```
id, filename, mimeType, size, created, author{displayName, accountId},
content (direct download URL), thumbnail (optional)
```

The `content` URL field (issue #585) is included here — #585 closes-as-fixed-by-#576 with no separate story. This struct is `#[derive(Debug, Clone, Serialize, Deserialize)]`; `size` is `u64`; `created` is `String` (ISO 8601, not parsed); `author` reuses the existing `User` type from `src/types/jira/user.rs` (already re-exported via `types/jira/mod.rs`).

#### `src/api/jira/attachments.rs` — **NEW**

Four HTTP call implementations against the Jira REST Attachment API:

| Function | Endpoint | Method |
|----------|----------|--------|
| `list_attachments(client, key)` | `GET /rest/api/3/issue/{key}?fields=attachment` | GET |
| `get_attachment_content(client, aid)` | `GET /rest/api/3/attachment/content/{id}` | GET (returns bytes) |
| `upload_attachment(client, key, paths)` | `POST /rest/api/3/issue/{key}/attachments` | POST multipart; requires `X-Atlassian-Token: no-check` |
| `delete_attachment(client, aid)` | `DELETE /rest/api/3/attachment/{id}` | DELETE (empty 204) |

`list_attachments` does not paginate — Jira returns the full `fields.attachment` array in one call (no cursor or pagination envelope; confirmed by Jira REST API v3 schema). **[P4-006 retro-annotation 2026-07-15: this claim is OVERSTATED — the research never validated the >100-attachment boundary; the v3 schema confirms no pagination envelope but does not document behaviour at large N. Downgrade to: ASSUMED complete per current API schema; NOT verified at large N. S1 delivery obligation: live-verify against a >100-attachment issue or document the unverified bound. BC-2.7.001 assumption clause governs.]** `get_attachment_content` streams bytes to disk rather than buffering in memory (use `reqwest::Response::bytes_stream()` + `tokio::io::copy`); avoids OOM for large attachments.

#### `src/cli/issue/attachments.rs` — **NEW**

Four handler functions dispatched from `cli/issue/mod.rs`:

| Handler | Command | Output channel profile |
|---------|---------|----------------------|
| `handle_attachment_list` | `jr issue attachment list <KEY>` | Read-only (profile 2): table to stdout; hints/filter-count to stderr |
| `handle_attachment_download` | `jr issue attachment download <KEY>` | Mixed (profile 3): no stdout data; progress/path hints to stderr; errors to stderr |
| `handle_attachment_upload` | `jr issue attachment upload <KEY>` | Symmetric (profile 4): JSON result to stdout (`--output json`); human echo to stdout; errors to stderr |
| `handle_attachment_delete` | `jr issue attachment delete` | Symmetric (profile 4): JSON result to stdout; human confirmation to stderr |

---

### 1.2 Touched files — dispatch surfaces

All four are minimal wiring changes. None cross the ADR-0012 1,000 LOC shard threshold.

| File | Change | Est. LOC delta |
|------|--------|---------------|
| `src/cli/mod.rs` | Add `Attachment { command: Box<AttachmentSubcommand> }` variant to `IssueCommand`; add `AttachmentSubcommand` enum with `List`, `Download`, `Upload`, `Delete` variants and their flag definitions | +80–100 LOC |
| `src/cli/issue/mod.rs` | Add `mod attachments;` declaration; add `IssueCommand::Attachment` match arm delegating to `attachments::handle_*` | +15–20 LOC |
| `src/types/jira/mod.rs` | Add `pub mod attachment;` and `pub use attachment::Attachment;` | +2 LOC |
| `src/api/jira/mod.rs` | Add `pub mod attachments;` | +1 LOC |

---

### 1.3 Touched files — build configuration

| File | Change |
|------|--------|
| `Cargo.toml` | Add `"multipart"` to reqwest features (see §4 Regression Risk — Blocker note) |

---

### 1.4 Oversized-file assessment

None of the three oversized files require changes for this feature:

| File | Current LOC | Touched? | Rationale |
|------|------------|---------|-----------|
| `src/cli/issue/list.rs` | 1,256 | NO | `jr issue list` does not render attachment columns; attachment list is a new subcommand, not a list flag |
| `src/cli/issue/edit.rs` | 2,067 | NO | Attachment upload/delete are not edit operations |
| `src/cli/issue/workflow.rs` | ~1,277 | NO | No workflow state changes |

`src/cli/issue/view.rs` (~287 LOC) is NOT currently required either — `jr issue view` does not render attachment metadata today (confirmed by grep; `fields.attachment` is not in the Issue type struct). A "Attachments:" display section in `view.rs` is a natural future enhancement (see §6 Open design questions) but is OUT OF SCOPE for this bundle.

---

### 1.5 Classification table

| Component | Classification | Rationale |
|-----------|---------------|-----------|
| `src/types/jira/attachment.rs` | NEW | Serde structs for attachment metadata |
| `src/api/jira/attachments.rs` | NEW | HTTP call implementations |
| `src/cli/issue/attachments.rs` | NEW | Subcommand handlers |
| `src/cli/mod.rs` | TOUCHED-DISPATCH | `IssueCommand::Attachment` variant + `AttachmentSubcommand` enum |
| `src/cli/issue/mod.rs` | TOUCHED-DISPATCH | mod decl + match arm |
| `src/types/jira/mod.rs` | TOUCHED-DISPATCH | mod decl + re-export |
| `src/api/jira/mod.rs` | TOUCHED-DISPATCH | mod decl |
| `Cargo.toml` | TOUCHED-CARGO | reqwest `"multipart"` feature |
| `src/cli/issue/list.rs` | NOT AFFECTED | — |
| `src/cli/issue/edit.rs` | NOT AFFECTED | — |
| `src/cli/issue/workflow.rs` | NOT AFFECTED | — |
| `src/cli/issue/view.rs` | NOT AFFECTED (this bundle) | — |
| `src/adf.rs` | NOT AFFECTED | Attachments carry no ADF content |
| `src/api/client.rs` | NOT AFFECTED | New attachment API functions call existing `JiraClient::get`/`post`/`delete`; no changes to client internals (redirect policy review is a design question, §6) |

---

## 2. Affected specs and BC placements

### 2.1 BC section placement

Attachment list and download are read operations → **Section 2 (Issue Read), new subsection 2.7**.
Attachment upload and delete are write operations → **Section 3 (Issue Write), new subsection 3.9**.

Following the append-only rule, the next free BC IDs at each section boundary are:
- `bc-2-issue-read.md`: currently ends at BC-2.6.051 → new section starts at **BC-2.7.001**
- `bc-3-issue-write.md`: currently ends at BC-3.8.017 → new section starts at **BC-3.9.001**

### 2.2 BC estimate by subsection

#### Section 2.7 — Attachment Read (list + download)

| BC | Subject |
|----|---------|
| BC-2.7.001 | `attachment list` table columns: id, filename, mimeType, size (human), created, author |
| BC-2.7.002 | `attachment list --output json` shape: `[{id, filename, mimeType, size, created, author, contentUrl}]` |
| BC-2.7.003 | `attachment list --filter mime=<glob>` client-side mimeType filter |
| BC-2.7.004 | `attachment list --filter name=<glob>` client-side filename filter |
| BC-2.7.005 | `attachment list --filter size-max=<bytes>` client-side size filter |
| BC-2.7.006 | `attachment list` on unknown KEY → exit 64 |
| BC-2.7.007 | `attachment download --id <AID>` single-file download; `--out <PATH>` override |
| BC-2.7.008 | `attachment download --all` batch download to `--out-dir <DIR>`; default dir is cwd |
| BC-2.7.009 | `attachment download --newest N` with optional `--filter` selecting most-recent N by created desc |
| BC-2.7.010 | SHA-1 filename idempotency: default output path is `<sha1>_<sanitized-basename>` |
| BC-2.7.011 | Filename sanitization: strip path separators and null bytes from Jira-supplied filename before disk write (CWE-22 mitigation; see §5) |
| BC-2.7.012 | `attachment download` on unknown KEY or unknown AID → exit 64 with clear error |

**Estimated: 12 BCs in Section 2.7**

#### Section 3.9 — Attachment Write (upload + delete)

| BC | Subject |
|----|---------|
| BC-3.9.001 | `attachment upload <KEY> --file <PATH>` multipart POST; `X-Atlassian-Token: no-check` header REQUIRED |
| BC-3.9.002 | Multiple `--file` flags supported; each is a separate multipart part in one POST |
| BC-3.9.003 | `attachment upload --replace-existing`: delete same-filename existing attachment(s) before uploading |
| BC-3.9.004 | `attachment upload --output json` shape: `[{id, filename, mimeType, size, contentUrl}]` (array; one element per uploaded file) |
| BC-3.9.005 | `attachment upload`: file not found or not readable → exit 64 before HTTP |
| BC-3.9.006 | `attachment delete <AID> [--yes]` interactive confirmation; `--yes` bypasses |
| BC-3.9.007 | `attachment delete --issue <KEY> --older-than <duration>` bulk date-filtered delete; `--dry-run` previews affected IDs |
| BC-3.9.008 | `attachment delete` idempotency: 404 from DELETE endpoint → exit 0 (attachment already gone; same pattern as `issue assign` idempotency) — **PHASE-DOC-RETRO-ANNOTATION (P14-004, 2026-07-16):** superseded by DEC-168. The shipped BC-3.9.008 specifies exit 64 + surface Jira body on 404, not exit 0. This F1-delta row was written before DEC-168 was ratified. Do not revert BC-3.9.008 toward exit 0 based on this row. |
| BC-3.9.009 | `attachment delete --output json` shape: `{"deleted": true, "id": str}` (single) or `{"deleted": true, "count": N, "ids": [str]}` (bulk) |
| BC-3.9.010 | `attachment delete --dry-run` output: table of IDs that would be deleted; no HTTP mutation; `--output json` shape: `{"dryRun": true, "ids": [str]}` |

**Estimated: 10 BCs in Section 3.9**

**Total new BCs: ~22 individually-bodied** (current canonical grand total: 624 → projected: 646).
Range-collapsed BCs (error shapes, filter combinations) will add to cumulative totals in bc-2 and bc-3 frontmatter.

### 2.3 NFR catalog touchpoints

| NFR | Touchpoint |
|-----|-----------|
| JSON render invariant (#526) | All `--output json` paths in attachments.rs MUST route through `output::render_json` or `output::print_output` |
| `--no-input` | `attachment delete` interactive prompt must be suppressed; `--yes` is the non-interactive equivalent |
| Exit codes | 64 = issue/attachment not found; 1 = network error; 2 = auth error; 130 = Ctrl+C |
| Idempotency | `attachment delete` on a 404 → exit 0 (documented above as BC-3.9.008) — **PHASE-DOC-RETRO-ANNOTATION (P14-004, 2026-07-16):** superseded by DEC-168; shipped BC-3.9.008 is exit 64 + surface body. |
| Output channel profiles | See §1.1 classification; list = profile 2 (read-only); download = profile 3 (mixed); upload/delete = profile 4 (symmetric) |
| `allow_hyphen_values` | Not needed — `--file <PATH>` is a path, not free text; paths starting with `-` are a deliberate edge case out of scope |

---

## 3. Perimeter scan

### 3.1 Spec artifacts

| Artifact | Required change |
|----------|----------------|
| `docs/specs/attachments.md` | **NEW** — feature spec required before F2 (policy: spec before implementation) — **PHASE-DOC-RETRO-ANNOTATION (P14-008, 2026-07-16):** this row originally implied the spec is required BEFORE F2 delivery. Clarification: `docs/specs/attachments.md` is an **F4 delivery obligation** — it must exist by the time the feature ships (story close), not necessarily before F2 spec-writing begins. F2 (PRD BCs) can proceed without it; F4 (implementation PR) must create it per ADR-0004 precedent. |
| `docs/specs/json-output-shapes.md` | Add rows: `attachment list`, `attachment download` (no JSON output; download writes files, not JSON), `attachment upload`, `attachment delete` (single + bulk) |
| `CHANGELOG.md` | New entry under next release tag: `feat(issue): attachment list/download/upload/delete subcommand tree (#576)` |

### 3.2 PRD / traceability artifacts

| Artifact | Required change |
|----------|----------------|
| `.factory/specs/prd/bc-2-issue-read.md` | Add Section 2.7 header + 12 BC bodies; update `total_bcs` frontmatter |
| `.factory/specs/prd/bc-3-issue-write.md` | Add Section 3.9 header + 10 BC bodies; update `total_bcs` frontmatter |
| `.factory/specs/prd/BC-INDEX.md` | Add `### 2.7 Attachments (Read)` and `### 3.9 Attachments (Write)` sections; update `total_bcs` header |
| `.factory/specs/prd/CANONICAL-COUNTS.md` | Update per-file `#### BC-` counts and grand total (624 → ~646) |
| `.factory/specs/prd/holdout-scenarios.md` | Add attachment scenarios: list on issue with 0 vs N attachments; download single/batch; upload new vs replace-existing; delete single/bulk dry-run; delete idempotency (404 → exit 0); path traversal filename (security holdout) |

### 3.3 CI / guard artifacts

| Artifact | Required change |
|----------|----------------|
| `tests/e2e_cli_surface_guard.rs` | Add SURFACE entries for all new `jr issue attachment` paths: `attachment list`, `attachment download`, `attachment upload`, `attachment delete` (with their flags); add parser-path consistency entries |
| `.cargo/mutants.toml` | Add `"src/cli/issue/attachments.rs"` and `"src/api/jira/attachments.rs"` to `examine_globs` — both are HIGH-value (routing forks for batch vs single, filter logic, replace-existing delete+re-upload, dry-run guard, idempotency sentinel) |
| `tests/mutants_glob_existence.rs` | Automatically validates new glob entries on CI — no manual change needed; the new files must exist when the test runs |

### 3.4 CLAUDE.md updates

Three sections need updating after implementation:

1. **Architecture src-tree** — add `attachments.rs` to `src/cli/issue/` and `src/api/jira/` listings
2. **Gotchas** — add: (a) `X-Atlassian-Token: no-check` required on upload POST, (b) `reqwest multipart` feature must be present in Cargo.toml, (c) filename sanitization strips path separators to prevent CWE-22, (d) redirect behavior on content download (see §5)
3. **AI Agent Notes** — no new env-var seams anticipated; however if an `attachment`-scoped cache is added (e.g., caching metadata per issue), it must follow the per-profile cache pattern and be documented here

---

## 4. Regression risk

### `Cargo.toml` — BLOCKER (must resolve at F2 spec / before S3)

`reqwest = { version = "0.13", default-features = false, features = ["json", "rustls"] }`

The `multipart` feature is **NOT enabled**. `reqwest::multipart::Form` is gated behind this feature. Adding `"multipart"` to the features list is required for upload. This is a low-risk additive change (no existing code is affected; the feature is an optional reqwest module), but it must be explicit in the story plan and called out for the security reviewer (multipart parsing adds a small incremental attack surface on the client side).

**Action:** Add `"multipart"` to reqwest features in Cargo.toml as part of the upload story (Story 3). The feature flag should not block Stories 1 and 2.

### `src/api/client.rs` — LOW

No changes to existing methods. New attachment functions in `src/api/jira/attachments.rs` call `client.get(…)`, `client.post(…)`, and `client.delete(…)` through the standard `JiraClient` interface. The `delete` convenience method exists on `JiraClient` (check: grep confirms `pub async fn delete` at client.rs). **Edge case:** `get_attachment_content` downloads raw bytes, not JSON — the standard `JiraClient::get_json::<T>` deserializer cannot be used; a new `get_bytes` or `get_raw` convenience method may be needed, OR the handler can call `self.client.get(url).send().await` directly. Either approach is confined to `attachments.rs`. Verify `JiraClient` exposes a path for raw response access before F2 story authoring.

### `src/api/jira/issues.rs` — NOT AFFECTED

`list_attachments` does NOT use `search_issues` or its pagination machinery. It calls a single `GET /rest/api/3/issue/{key}?fields=attachment` — a direct issue fetch, not a JQL search. The JRACLOUD-95368 anti-loop guard and cursor pagination are irrelevant here.

### `src/types/jira/issue.rs` — POTENTIALLY TOUCHED

Currently `Issue` struct does not include `fields.attachment` (confirmed by grep). If `jr issue view` is ever extended to display attachment counts, `Issue` would need an `attachment: Option<Vec<Attachment>>` field. That is **out of scope for this bundle**; `list_attachments` fetches attachment data via a separate GET call with `?fields=attachment`, returning a response struct dedicated to that field, not reusing `Issue`.

### `src/adf.rs`, `src/cache.rs` — NOT AFFECTED

Attachments do not use ADF. No cache design for attachment metadata is planned (the list call is a fast single-GET; caching attachment lists would create staleness issues for upload/delete operations and offers minimal benefit).

---

## 5. Security-relevant design questions (F1 gate)

These questions MUST be answered in the feature spec (`docs/specs/attachments.md`) before F2 story authoring. **Security reviewer is REQUIRED at F2** (precedent: DEC-168 required security review for comment CRUD because visibility flags touched access-control semantics; attachment operations carry higher inherent risk — filesystem write, SSRF-adjacent redirect behavior, multipart boundary injection, and CWE-22 path traversal all require explicit mitigation decisions).

### SQ-1: Filename sanitization (CWE-22 / path traversal)

Jira's API returns `filename` as a string from the server. A malicious or misconfigured Jira instance could return filenames containing `../` sequences, absolute paths (`/etc/passwd`), or null bytes. When `attachment download` writes to disk, it must sanitize the filename before constructing the output path.

**Required decision:** Specify the exact sanitization algorithm. Recommended: strip all `/`, `\`, `:`, null bytes, and leading `.` sequences; truncate to a platform-safe length. Implement as a `sanitize_attachment_filename(name: &str) -> String` free function in `src/cli/issue/attachments.rs` covered by unit tests. The SHA-1 prefix in the default output filename (`<sha1>_<sanitized-basename>`) provides additional defense in depth.

### SQ-2: Redirect following with credentials (SSRF-adjacent)

`GET /rest/api/3/attachment/content/{id}` on Jira Cloud redirects to an Atlassian CDN URL (typically `api.media.atlassian.com` or a signed S3 URL). The current `JiraClient` uses `Client::builder().timeout(Duration::from_secs(30)).build()` with no explicit redirect policy — reqwest follows redirects and, by default, strips `Authorization` headers on cross-origin redirects (per `reqwest` 0.13 implementation of the Fetch spec's redirect stripping behavior).

**Required decision:** Confirm via source inspection of reqwest 0.13 that `Authorization` headers are stripped on cross-origin redirect. If confirmed, no action is needed — the CDN GET should succeed without credentials (Jira issues signed CDN URLs that don't require re-authentication). If reqwest forwards auth headers cross-origin, add `.redirect(reqwest::redirect::Policy::limited(10))` with a custom policy that strips the `Authorization` header on non-Atlassian redirects. Document the confirmed behavior in the feature spec.

### SQ-3: `X-Atlassian-Token: no-check` on upload

Jira's XSRF protection requires this header on `POST /rest/api/3/issue/{key}/attachments`. Without it, the upload returns 403 Forbidden. This is an Atlassian API requirement, not a security risk in `jr` itself — but it must be added explicitly in `upload_attachment` and tested with a wiremock integration test that asserts the header is present.

### SQ-4: Overwrite semantics on download

If `--out <PATH>` or `--out-dir <DIR>/<filename>` points to an existing file, does `jr` overwrite silently or error?

**Required decision:** Default should be ERROR (exit 64 with "file already exists; use --force to overwrite") to prevent silent data loss. `--force` flag to allow overwrite. This is a UX/safety decision that must be in the spec before stories are written.

### SQ-5: Upload size limits and 413 handling

Jira Cloud's default attachment size limit is 10 MB per file (instance-configurable). The `upload` handler should:
1. Check file size BEFORE POSTing to provide a user-friendly error rather than waiting for a 413.
2. Handle a 413 response gracefully: exit 64 with "File exceeds Jira attachment size limit".

**Required decision:** Should the pre-check fetch the instance attachment limit via `/rest/api/2/configuration` (one extra GET per upload) or use a compiled-in safe default (e.g., 10 MB)? The compiled-in default is simpler and avoids an extra API call; the `jr init` command could optionally cache the limit. Document the chosen approach.

### SQ-6: Multipart boundary injection

Filenames and file content used in `reqwest::multipart::Form` construction must not allow boundary injection. reqwest's multipart builder handles this correctly by quoting filenames in the `Content-Disposition` header. **Verify** that `reqwest 0.13`'s multipart implementation quotes filenames containing special characters (e.g., `"`, `;`, newlines) — a quick read of reqwest 0.13 source suffices. Document the finding in the feature spec.

---

## 6. Story count, wave shape, and route recommendation

### Stories

| Story | Title | New files created | Cargo.toml change? |
|-------|-------|-------------------|-------------------|
| S1 | Attachment list + type structs (closes #585) | `src/types/jira/attachment.rs`, `src/api/jira/attachments.rs` (list only), `src/cli/issue/attachments.rs` (list only), dispatch wiring in 4 files | No |
| S2 | Attachment download (single + batch + newest) | extends `src/api/jira/attachments.rs` + `src/cli/issue/attachments.rs` | No |
| S3 | Attachment upload (multipart) | extends same two files | **Yes** — adds `"multipart"` to reqwest features |
| S4 | Attachment delete (single + bulk + dry-run) | extends same two files | No |

S1 is the foundation: it creates the shared type structs and dispatch wiring that S2–S4 extend. S2 and S3 are independent of each other but both depend on S1's type structs. S4 is independent of S2 and S3. All four stories can be sequenced in a single wave with S1 delivered first (dependency is compile-time, not runtime).

### #585 disposition

Issue #585 ("include attachment content URL in metadata response") is fully addressed by including `content: String` in `src/types/jira/attachment.rs` and surfacing it in `attachment list --output json`. No separate story needed. Close #585 as **fixed-by #576** after S1 ships.

### Wave shape

```
Wave 1 (sequential):
  S1 (list + types) → merge
  S2 (download)     → merge
  S3 (upload)       → merge
  S4 (delete)       → merge
```

All four stories are independent enough to be reviewed and merged serially in one wave. No parallelism is needed given S1→S2/S3/S4 type-struct dependency. Estimated delivery: 4–6 developer-days.

### Route recommendation

**Standard** (not quick-dev). Rationale:

1. Security reviewer is REQUIRED at F2 (SQ-1 through SQ-6 above; precedent DEC-168)
2. Cargo.toml feature addition (reqwest multipart) requires explicit sign-off
3. New subcommand tree with 4 operations, cross-cutting BC coverage in two PRD sections, and e2e test additions — scope exceeds the quick-dev threshold
4. CWE-22 mitigation (filename sanitization) requires formal behavioral contract (BC-2.7.011) and holdout scenario before implementation

Quick-dev is appropriate for single-file bug fixes with no security surface; this feature does not qualify.

---

## 7. CI checkout topology check (F1-CI-TOPOLOGY-CHECK)

All CI jobs in `.github/workflows/ci.yml` use a pinned SHA:

```
actions/checkout@9c091bb21b7c1c1d1991bb908d89e4e9dddfe3e0  # v7.0.0
```

This SHA appears consistently across all 10 job definitions verified in the ci.yml scan. The `ci-gate` job (job name "CI Gate") is confirmed as the single aggregating required check — it uses `needs:` to gate on the matrix jobs, and branch protection references only `ci-gate`. No topology drift detected. New CI jobs added for this feature (if any) MUST be added to `ci-gate.needs` rather than wired directly into branch protection (DEC-096/DEC-097 rule).

No separate CI jobs are anticipated for this feature — the existing `build`, `test`, `clippy`, `fmt`, `deny` jobs will cover the new code automatically.

---

## 8. Open design questions for the human F1 gate

The following questions require a human decision before the F2 spec can be written:

| # | Question | Default recommendation |
|---|---------|----------------------|
| OQ-1 | Should `attachment list` also display attachments inline in `jr issue view`? Or is the separate subcommand the only surface? | Separate subcommand only (this bundle); view.rs is a future enhancement |
| OQ-2 | Overwrite semantics on `attachment download --out <PATH>` (SQ-4): error by default, `--force` to overwrite? | Yes — error by default |
| OQ-3 | Upload size pre-check: compiled-in 10 MB default or dynamic fetch from `/rest/api/2/configuration`? | Compiled-in default + graceful 413 handling |
| OQ-4 | Should `attachment delete --older-than <duration>` require `--yes` by default (no interactive prompt when `--older-than` is set)? | Yes — bulk operations should require explicit `--yes` |
| OQ-5 | Should `attachment download` support `--output json` to emit a manifest of downloaded files? | Desirable for scripting (`[{id, filename, path, sha1}]`); add as BC-2.7.013 if approved |
| OQ-6 | `attachment upload` with `--replace-existing`: if multiple same-filename attachments exist, delete ALL before re-uploading, or error? | Delete all (last-write-wins) |
| OQ-7 | Is `jr issue attachment delete <AID>` (by attachment ID only, without `--issue KEY`) the right primary form, or should all forms require `--issue KEY` for safety? | ID-only is correct for single delete (matches Jira API signature); `--issue KEY --older-than` requires the key |

---

## Summary for F1 gate decision (Rev 1 — superseded by Rev 2 below)

**Impact boundary:** 3 NEW files (`attachment.rs` type struct, `attachments.rs` API module, `attachments.rs` CLI handler) + 4 minimal dispatch-surface TOUCHES + 1 Cargo.toml feature addition. Zero oversized files (list.rs, edit.rs, workflow.rs) need modification.

**BC estimate:** ~22 new individually-bodied BCs across two new subsections (2.7 and 3.9). Grand total rises from 624 to ~646.

**Security posture:** Security reviewer REQUIRED at F2. Six design questions (SQ-1 through SQ-6) covering CWE-22, redirect+credential forwarding, XSRF header, overwrite safety, 413 handling, and multipart boundary injection must be answered in the feature spec.

**Recommended route:** Standard. **Wave shape:** 4 stories, 1 wave, S1→S2/S3/S4 serial.

**#585 disposition:** Folds into Story 1 (contentUrl field in attachment type struct). Close as fixed-by #576 after S1 merges.

---

## Revision 2 — JSM upload visibility in scope + research findings incorporated

- **Revision date:** 2026-07-15
- **F1 gate status:** APPROVED 2026-07-15 (DEC-179) — zero open design questions; ready for F2 spec handoff
- **Research basis:** `.factory/research/issue-576-attachments-api-2026-07-15.md` Part 2 (JSM two-step upload deep-dive; P2-1 through P2-8)
- **Human rulings baked in:** JSM upload visibility IN SCOPE this bundle; download overwrite = refuse existing + `--force`; upload size = no hard-coded cap, graceful 413 + `size` field; #585 absorbed into S1.

### R2.1 Impact boundary additions

The JSM `--public` upload path requires a dedicated API module and type structs on the JSM side. These were not in Rev 1.

#### New files added by JSM scope expansion

**`src/types/jsm/attachment.rs` — NEW**

Two serde structs for the `attachTemporaryFile` response (confirmed shape; P2-1b):

```
TempAttachmentResponse { temporary_attachments: Vec<TempAttachment> }
TempAttachment { temporary_attachment_id: String, file_name: String }
```

The response shape for `POST /rest/servicedeskapi/request/{id}/attachment` is **INCONCLUSIVE** (P2-3c — Cloud schema not published in research sources). The implementer must capture the live shape during the gated EJ e2e run and pin a serde struct from real responses rather than guessing. This is a **delivery obligation for S5**, not an F1 blocker.

**`src/api/jsm/attachments.rs` — NEW**

Two API call implementations for the JSM two-step flow:

| Function | Endpoint | Notes |
|----------|----------|-------|
| `attach_temporary_file(client, service_desk_id, paths)` | `POST /rest/servicedeskapi/servicedesk/{sdId}/attachTemporaryFile` | Multipart; `X-Atlassian-Token: no-check`; returns `Vec<TempAttachment>` |
| `attach_to_request(client, issue_key, temp_ids, public)` | `POST /rest/servicedeskapi/request/{issueKey}/attachment` | JSON body; `additionalComment` omitted (optional per P2-3b) |

The `serviceDeskId` is resolved by the caller (the upload handler) via the existing `require_service_desk` path in `src/api/jsm/servicedesks.rs` — no new serviceDeskId resolution function needed; the existing `get_or_fetch_project_meta` chain is reused. **[P6-001/P6-004 retro-correction 2026-07-15: (1) the internal match is by `projectId` (numeric), NOT `projectKey` string — `get_or_fetch_project_meta` calls `GET /rest/api/3/project/{key}` to extract the numeric `project_id`, then matches service desks by `d.project_id == project_id`; the `project_key` is only the cache-lookup key for `project_meta.json`. (2) No new cache is needed — the existing `ProjectMeta.service_desk_id` field is ALREADY stored in the `project_meta.json` cache by `get_or_fetch_project_meta`; BC-X.8.010 as originally planned (new dedicated cache family) is WITHDRAWN — P6-004 simplification. **[SUBSEQUENTLY REVISED — see R2.3/lines 490-492: BC-X.8.010 IS REWRITTEN TO REUSE, not withdrawn; BC survives as the resolution+self-heal reuse-contract; counts 657/96 unchanged]** `require_service_desk` already avoids the repeated paginated scan via the existing `ProjectMeta` cache.]**

#### Additional dispatch surfaces touched (JSM side)

| File | Change | Est. LOC delta |
|------|--------|---------------|
| `src/types/jsm/mod.rs` | Add `pub mod attachment;` + re-exports | +3 LOC |
| `src/api/jsm/mod.rs` | Add `pub mod attachments;` | +1 LOC |

#### Cargo.toml — revised feature additions (now TWO reqwest features + one direct dep)

| Addition | Reason | Research basis |
|----------|--------|---------------|
| reqwest `"multipart"` | Upload multipart form body | P2-1 (platform + JSM temp-upload both multipart) |
| reqwest `"stream"` | Download streaming via `bytes_stream()` — avoids whole-body OOM for large attachments | Part 1 §3b |
| `tokio-util` direct dep | `ReaderStream` for streaming file into multipart `Part` | P2-8: already transitive in `Cargo.lock` → no new supply-chain surface, just a direct-dep declaration |

Rev 1 listed only `"multipart"`. The `"stream"` feature addition and `tokio-util` direct dep are new findings from Part 2. `cargo deny check` already passes clean (P2-8 confirmed: no RustSec/GHSA advisories against reqwest 0.13.x multipart/stream or tokio-util 0.7.x); the PR `cargo deny` gate will re-verify automatically.

#### Revised classification table (delta from Rev 1)

| Component | Classification | Rev 1 status |
|-----------|---------------|-------------|
| `src/types/jsm/attachment.rs` | NEW | not present |
| `src/api/jsm/attachments.rs` | NEW | not present |
| `src/types/jsm/mod.rs` | TOUCHED-DISPATCH | not present |
| `src/api/jsm/mod.rs` | TOUCHED-DISPATCH | not present |
| `Cargo.toml` | TOUCHED-CARGO (multipart + stream + tokio-util) | multipart only |
| `src/api/jsm/servicedesks.rs` | DEPENDENT (call site only; no modifications to existing functions) | not listed |
| `src/cache.rs` | TOUCHED for serviceDeskId cache (model-b writer, new `write_service_desk_id_cache` / `read_service_desk_id_cache` functions; BC-X.8.010 candidate) **[P6-004 retro-correction 2026-07-15: NOT TOUCHED — no new cache functions needed. Existing `ProjectMeta.service_desk_id` in `project_meta.json` already caches the serviceDeskId via `write_project_meta`/`read_project_meta`. Classification changes to NOT AFFECTED.]** | NOT AFFECTED |

All Rev 1 classifications are otherwise unchanged.

---

### R2.2 Design model for JSM upload visibility (P2-4a finding)

**The key research finding (P2-4a, HIGH confidence) reverses the Part 1 risk framing:**

Platform `POST /rest/api/3/issue/{key}/attachments` on a JSM issue is **INTERNAL by default** — the attachment is NOT shown on the customer portal unless subsequently surfaced in a public reply comment. The dangerous direction is opting INTO customer-visibility, not defaulting into it.

**Adopted design (mirrors BC-3.5.006 `comment edit --public/--internal` precedent):**

- `attachment upload <KEY> --file <PATH>` with no visibility flag → **platform POST** (works on both JSM and non-JSM; safe/internal result on JSM; no servicedeskapi call)
- `attachment upload <KEY> --file <PATH> --public` → **servicedeskapi two-step** (attachTemporaryFile → request/{id}/attachment with `public: true`); requires JSM project; requires confirmation gate (see SQ-7)
- `attachment upload <KEY> --file <PATH> --internal` → **servicedeskapi two-step** with `public: false`; requires JSM project; no confirmation gate (internal is the safe direction)
- `--public` or `--internal` on a non-JSM issue → exit 64 with clear message: "`--public/--internal` requires a Jira Service Management project"; the raw servicedeskapi 404 MUST be intercepted and replaced with this user-visible message (P2-4b). **[PHASE-DOC-RETRO-ANNOTATION 2026-07-15 — CONS-576-006: The `--internal` on non-JSM case above is SUPERSEDED BY OQ-9 (later in this document, §Open Questions table). OQ-9 was RATIFIED 2026-07-15: `--internal` on non-JSM = silent no-op (not exit 64). Rationale: platform POST is already internal by default (P2-4a); asserting `--internal` on a non-JSM issue is coherent and harmless — DEC-169 leniency family. `--public` on non-JSM remains exit 64 (unchanged). BC-3.9.004 implements the OQ-9 ruling correctly. This annotation is informational; the original R2.2 text is preserved for audit trail.]**

The `--internal` flag on upload is symmetric with `comment edit --internal` even though it mirrors the default — it provides an explicit opt-in for scripts that want to assert internal visibility on JSM uploads without relying on the platform-default.

---

### R2.3 Revised BC estimate

#### Section 3.9 additions for JSM visibility (appends to the 10 BCs in Rev 1)

| BC | Subject |
|----|---------|
| BC-3.9.011 | `attachment upload --public <KEY>` routes through servicedeskapi two-step; `--public` requires a JSM project (exit 64 with clear message on non-JSM; intercepted 404) |
| BC-3.9.012 | `attachment upload --internal <KEY>` routes through servicedeskapi two-step with `public: false`; same JSM-only gate as `--public` **[PHASE-DOC-RETRO-ANNOTATION 2026-07-15 — NEW-005/CONS-576-006: "same JSM-only gate as `--public`" SUPERSEDED BY OQ-9 for the `--internal` case. `--internal` on non-JSM = silent no-op, NOT exit 64. `--public` on non-JSM remains exit 64. See §R2.2 CONS-576-006 annotation and §OQ-9 RATIFIED row. BC-3.9.004 is the correct current spec for `--internal` non-JSM behavior.]** |
| BC-3.9.013 | `attachment upload --public` interactive confirmation gate: "This will make the attachment visible on the customer portal. Continue? [y/N]"; `--yes` bypasses (mirror BC-3.5.007) |
| BC-3.9.014 | `attachment upload --public --output json` shape: array with an `internal: false` (or `public: true`) boolean indicating portal visibility; shape finalized after live EJ e2e capture (P2-3c INCONCLUSIVE delivery obligation) |

**Estimated: 14 BCs in Section 3.9** (10 from Rev 1 + 4 JSM visibility)

> **[PLANNED→AUTHORED ID DRIFT retro-annotation 2026-07-15 (PG-F3-1 verify-before-cite class):** The four planned IDs above do NOT match the authored IDs in `bc-3-issue-write.md`. The PO reorganized the Section 3.9 numbering when authoring — inserting additional BCs earlier in the sequence caused all four R2.3 planned IDs to shift. Full mapping (verified against `#### BC-3.9.0NN` headings in the authored spec):
>
> | Planned (this table) | Authored (`bc-3-issue-write.md`) | Subject |
> |----------------------|----------------------------------|---------|
> | BC-3.9.011 | **BC-3.9.003** | `--public` flag → servicedeskapi two-step routing + JSM-only gate |
> | BC-3.9.012 | **BC-3.9.004** | `--internal` flag → servicedeskapi two-step; non-JSM = silent no-op (OQ-9) |
> | BC-3.9.013 | **BC-3.9.014** | `--public` interactive confirmation gate mechanics (DEC-174) |
> | BC-3.9.014 | **BC-3.9.011** | `--public --output json` shape — deferred-probe contract (P2-3c) |
>
> The R3.5 planned BCs (BC-3.9.015–020) match authored IDs exactly and are NOT affected.
>
> **Lesson (PG-F3-1):** planning tables record intent at estimation time; authored IDs are ground truth and must be re-verified against the spec file post-authoring before being cited in any downstream artifact (stories, F3 test stubs, F4 implementation notes, or this analysis). Any citation of a Section 3.9.011–014 BC in this document that predates this annotation should be read as citing the authored ID per the mapping above.]

#### Cross-cutting addition for serviceDeskId cache

| BC | Subject |
|----|---------|
| BC-X.8.010 | `(profile, projectKey) → serviceDeskId` cache: 7-day TTL; model-b writer (swallow+warn on disk-write failure; mirrors `write_cmdb_fields_cache`); cache miss → paginated `GET /rest/servicedeskapi/servicedesk` scan with `projectKey` match; used by `attach_temporary_file` caller path **[P6-001/P6-004 retro-correction 2026-07-15: BC-X.8.010 IS REWRITTEN TO REUSE (not withdrawn). (1) The resolution chain matches by `projectId` (numeric), not `projectKey` string — `get_or_fetch_project_meta` fetches `GET /rest/api/3/project/{key}` to get the numeric id, then matches `d.project_id == project_id`; `project_key` is only the outer HashMap cache key. (2) No new cache FILE or writer — the existing `ProjectMeta.service_desk_id` already covers this via `write_project_meta`/`read_project_meta` in `project_meta.json`. BC-X.8.010 SURVIVES as the contract for: (a) serviceDeskId resolution reading through the existing `get_or_fetch_project_meta` cache-backed path, and (b) SEC-576-006 stale-ID self-heal semantics (invalidate project-meta entry → re-resolve once → per-status mapping). BC-X.8.010 must still be authored in `cross-cutting.md`; counts unchanged: 657 BCs / 96 holdouts; `### X.8` = 10 BCs.]** |

**Net new individually-bodied BCs: ~27** (12 Section 2.7 + 14 Section 3.9 + 1 BC-X.8.010) **[P6-004 retro-correction 2026-07-15: BC-X.8.010 REWRITTEN TO REUSE — BC retained; counts unchanged: ~27 net new (12 + 14 + 1).]**

**Revised grand total: 624 → ~651.**

---

### R2.4 Revised story count and wave shape

**Recommendation: JSM `--public`/`--internal` upload becomes Story 5 (S5), not folded into S3.**

Rationale:
- S5 requires two new files (`src/api/jsm/attachments.rs`, `src/types/jsm/attachment.rs`) that are independent of S3's multipart platform upload code
- S5 has a INCONCLUSIVE response schema (P2-3c) that blocks finalizing BC-3.9.014 **[PLANNED ID — authored as BC-3.9.011; see R2.3 drift annotation]** until the live EJ e2e run — this gated obligation fits a standalone story better than embedding it inside S3
- S5 introduces serviceDeskId resolution cache (`src/cache.rs` writer) **[P6-004 retro-correction 2026-07-15: S5 does NOT introduce a new cache — it reuses the existing `ProjectMeta.service_desk_id` cache via `get_or_fetch_project_meta`/`require_service_desk`. `src/cache.rs` is NOT touched by S5.]** — a cross-cutting concern that should be reviewed independently of multipart upload
- S5's confirmation gate (SQ-7) is a new UX pattern for upload operations — isolating it in S5 keeps S3 focused on the core multipart machinery
- Folding would make S3 a multi-concern story with disparate review surface (platform multipart + JSM two-step + cache + confirmation gate)

**Revised wave:**

```
Wave 1 (sequential):
  S1 (list + type structs; closes #585) → merge
  S2 (download — single/batch/newest)   → merge
  S3 (upload — platform path)           → merge
  S4 (delete — single/bulk/dry-run)     → merge
  S5 (upload --public/--internal — JSM two-step; gated EJ e2e) → merge
```

S5 depends on S3 only for the shared `Attachment` type struct (already present after S1) and the `X-Atlassian-Token` pattern precedent. It is otherwise independent and can be developed while S4 is in review. The wave is still 1 wave (all 5 stories ship in the same release increment).

**Estimated delivery: 6–8 developer-days** (revised upward from 4–6 in Rev 1 due to JSM scope).

---

### R2.5 Resolved and revised security questions

#### SQ-2 — RESOLVED (no action needed)

Research (P2-8) confirmed that reqwest 0.13.x strips `Authorization`, `Cookie`, and `Proxy-Authorization` headers on cross-host redirects by default. The GHSA-9857-6MW7-FQ2M advisory (against `gix-transport`, not reqwest) explicitly states reqwest's default redirect policy compares `prev_url.host_str()` to `curr_url.host_str()` and strips sensitive headers on cross-domain hops — this is the exact behavior the download path relies on. No custom `RedirectPolicy` is needed. The feature spec should document this as a positive finding (no code change required; just cite the research).

#### SQ-5 — Revised (no hard-coded size cap)

Original Rev 1 recommendation (compiled-in 10 MB default) is withdrawn. Research (§3a, P2-7) confirmed the cap is site-configurable and sources conflict on the number (low-MB legacy vs. low-GB current admin doc). The correct posture:
- **No pre-check against a hard-coded cap** — streaming upload via `ReaderStream` means the CLI never buffers the whole file in memory regardless of size
- **Handle 413 gracefully**: exit 64 with a message like "Attachment rejected: file exceeds this Jira instance's size limit (check site configuration)" — no assumed number
- The `size` field in `attachment list --output json` metadata is authoritative for `--filter size-max=` comparisons

#### SQ-7 — RATIFIED: `--public` upload confirmation gate

**Human ruling received 2026-07-15.** `attachment upload --public` REQUIRES the y/N confirmation gate. This is no longer an open question — it is a ratified design input. The exact house pattern is:

- **Interactive TTY:** `eprint!` the prompt to stderr followed by `stdin read_line` (the DEC-174 ratified pattern — **NOT `dialoguer::Confirm`**, which is unusable when stderr is piped)
- **Non-interactive** (`--no-input` or stdin not a TTY): exit 64 with a `--yes` hint on stderr
- **`--yes` flag:** bypasses the gate (non-interactive equivalent)
- **`--yes` without `--public`:** silent no-op (DEC-169 leniency convention — the flag is accepted and ignored when no visibility-gated operation is being performed)
- **Cancel path:** returns the cancelled JSON shape consistent with `comment edit --public` cancel: `{"cancelled": true, "uploaded": false}` (no `id`/`key` in cancel shape)

**Precedent BCs for F2 spec authors:** BC-3.5.007 (the `comment edit --public` always-confirm rule), DEC-169 (leniency convention for `--yes` without a gated flag), DEC-174 (ratified `eprint!+read_line` interactive pattern vs. `dialoguer::Confirm`). The F2 spec for BC-3.9.013 **[PLANNED ID — authored as BC-3.9.014; see R2.3 drift annotation]** MUST cite all three and mirror the exact implementation pattern from `src/cli/issue/interactions.rs::handle_comment_edit` (the `--public` branch).

---

### R2.6 EJ e2e obligations (new; gated by `JR_E2E_JSM_PROJECT`)

Story 5 (JSM `--public` upload) incurs these e2e obligations beyond the standard platform tests:

| Obligation | Mechanism |
|-----------|----------|
| S5 upload live run against EJ project | `JR_E2E_JSM_PROJECT`-gated test; `--public` variant creates an attachment visible on portal; `--internal` variant creates internal attachment |
| Post-upload verify via platform endpoint | After JSM upload, verify via `GET /rest/api/3/issue/{key}?fields=attachment` (NOT via servicedeskapi `links.content` — JSDCLOUD-10841 makes those unreliable; P2-6) |
| Capture live `request/{id}/attachment` response shape | Pin serde struct for BC-3.9.014 **[PLANNED ID — authored as BC-3.9.011; see R2.3 drift annotation]** from real response; INCONCLUSIVE in research (P2-3c) |
| `jsm_self_close` teardown | All JSM write tests created by S5 must use `jsm_self_close` convention (dynamic transition discovery + resolution; `JR_E2E_JSM_RESOLUTION` env override; fail-silent teardown) — same convention as existing JSM create tests |

These obligations are delivery gates for S5, not F1 blockers.

---

### R2.7 Perimeter scan additions (delta from Rev 1)

| Artifact | Rev 2 addition |
|----------|---------------|
| `docs/specs/attachments.md` | Must add JSM two-step flow design, `--public`/`--internal` flag semantics, serviceDeskId resolution strategy, confirmation gate spec, and EJ e2e delivery obligations |
| `.factory/specs/prd/cross-cutting.md` | Add `BC-X.8.010` (serviceDeskId cache); update `### X.8` section header from `(9 BCs: BC-X.8.001..009)` to `(10 BCs: BC-X.8.001..010)` **[P6-004 retro-correction 2026-07-15: BC-X.8.010 REWRITTEN TO REUSE — BC retained as the resolution+self-heal contract; authored with reuse of `get_or_fetch_project_meta`+`ProjectMeta.service_desk_id`; no new cache functions. `cross-cutting.md` still touched; `### X.8` updates to 10 BCs as planned.]** |
| `.factory/specs/prd/BC-INDEX.md` | Update `### X.8` section count; add BC-X.8.010 to the listing **[P6-004 retro-correction 2026-07-15: BC-X.8.010 REWRITTEN TO REUSE — BC retained; `BC-INDEX.md` `### X.8` entry still added as planned.]** |
| `.factory/specs/prd/CANONICAL-COUNTS.md` | Grand total revised: 624 → ~651 (+27 individually-bodied) **[P6-004 retro-correction 2026-07-15: BC-X.8.010 REWRITTEN TO REUSE — BC retained; grand total 624 → ~651 unchanged (657 BCs / 96 holdouts).]** |
| `tests/e2e_cli_surface_guard.rs` | Add SURFACE entries for `attachment upload --public`, `attachment upload --internal`, `attachment upload --yes` |
| `.cargo/mutants.toml` | Add `"src/api/jsm/attachments.rs"` to `examine_globs` — HIGH-value: two-step orchestration, `public` boolean routing, service-desk-not-found intercepted-404 guard |
| `CLAUDE.md` Gotchas | Add: (a) `attachment upload` default = platform POST (internal on JSM); `--public` = servicedeskapi two-step; (b) serviceDeskId cache model-b writer in `src/cache.rs` **[P6-004 retro-correction 2026-07-15: item (b) REWRITTEN TO REUSE — no new cache writer. CLAUDE.md Gotcha should read: `--public` upload resolves serviceDeskId via the existing `get_or_fetch_project_meta`+`require_service_desk` cache-backed path (`ProjectMeta.service_desk_id` in `project_meta.json`); no new `src/cache.rs` function. BC-X.8.010 documents the resolution+stale-ID-self-heal contract.]**; (c) JSDCLOUD-10841 — use platform content endpoint for download even for JSM issues; (d) temp attachment TTL ≈ 1 hour (non-issue for CLI's back-to-back two-step; surface expiry failures as "temporary upload expired — retry" hint) |

---

### R2.8 Revised summary for re-presented F1 gate

**Revised impact boundary:** 5 NEW files (platform `attachment.rs` + `attachments.rs` + `attachments.rs`; JSM `attachment.rs` + `attachments.rs`) + 6 minimal dispatch-surface TOUCHES (4 platform + 2 JSM) + Cargo.toml (2 reqwest features + 1 direct dep promotion). Zero oversized files touched.

**Revised BC estimate:** ~27 new individually-bodied BCs: 12 in new Section 2.7, 14 in new Section 3.9, 1 in Section X.8. Grand total 624 → ~651.

**Revised story count:** 5 stories, 1 wave (S1 list → S2 download → S3 platform upload → S4 delete → S5 JSM visibility upload). Estimated delivery 6–8 developer-days.

**Security posture:** Security reviewer REQUIRED at F2. SQ-2 RESOLVED (reqwest strips auth headers on redirect — no code change needed). SQ-5 REVISED (no hard-coded cap; stream + graceful 413). SQ-7 NEW (recommend `--public` confirmation gate, mirroring BC-3.5.007). SQ-1, SQ-3, SQ-4, SQ-6 carry forward unchanged from Rev 1.

**Remaining open questions for F2 spec:**

| # | Question | Status |
|---|---------|--------|
| OQ-1 | `attachment list` in `jr issue view` | OUT OF SCOPE this bundle (unchanged) |
| OQ-2 | Overwrite on download | RULED: refuse + `--force` |
| OQ-3 | Upload size pre-check | RULED: no hard-coded cap; stream + 413 handling |
| OQ-4 | Bulk delete `--older-than` requires `--yes` | Recommendation unchanged: YES |
| OQ-5 | Download `--output json` manifest | Pending; add as BC-2.7.013 if approved |
| OQ-6 | `--replace-existing` on filename collision | Recommendation unchanged: delete all |
| OQ-7 | `delete <AID>` without `--issue KEY` | Recommendation unchanged: ID-only correct |
| OQ-8 | `--public` confirmation gate | **RATIFIED 2026-07-15** — gate required; `eprint!+read_line` pattern (DEC-174, NOT dialoguer::Confirm); non-interactive → exit 64 + `--yes` hint; `--yes` without `--public` = silent no-op (DEC-169); cancel shape `{"cancelled": true, "uploaded": false}`. F2 spec must cite BC-3.5.007 + DEC-169 + DEC-174 and mirror `handle_comment_edit` --public branch. |
| OQ-9 | `--internal` flag on platform (non-JSM) issues | **RATIFIED 2026-07-15** — silent no-op; rationale: a non-JSM issue has no customer portal, so the attachment is already internal by nature; explicitly asserting `--internal` is coherent and harmless (DEC-169 / `--no-resolution` leniency family). Contrast: `--public` on non-JSM stays exit 64 (impossible intent — no portal to publish to). |

---

## Revision 3 — Adversary-pass-1 scope repair + human rulings

- **Revision date:** 2026-07-15
- **Trigger:** Adversary pass 1 (ADV-576-P1-001, ADV-576-P1-003, ADV-576-P1-004) + human rulings at the adversary-pass-1 checkpoint

### R3.1 Command-path confirmation (ADV-576-P1-001)

The subcommand path `jr issue attachment <verb>` is confirmed for ALL verbs: `list`, `download`, `upload`, `delete`. There is no alternative nesting (e.g., `jr attachment` at the top level). This is the only surface registered in `IssueCommand::Attachment { command: Box<AttachmentSubcommand> }` and in the `SURFACE` table of `tests/e2e_cli_surface_guard.rs`. All dispatch wiring, SURFACE entries, and BC identifiers in Rev 1 and Rev 2 are consistent with this path — no correction needed to prior revisions.

### R3.2 Silent-drop repair: `--replace-existing`, `--older-than`, `--dry-run` IN SCOPE (ADV-576-P1-003)

Adversary pass 1 flagged that these three flags, present in the Rev 1 BC estimate (BC-3.9.003, BC-3.9.007, BC-3.9.010), were not explicitly carried forward in Rev 2's story narrative and perimeter scan. **Human ruling (2026-07-15):** all three are IN SCOPE for this bundle.

**`--replace-existing` on upload (BC-3.9.003 repaired + extended):**

The replace-existing flow deletes same-filename existing attachments before uploading. JRACLOUD-96384 (confirmed; §6 of the research file) documents that Jira matches media references to attachments by `filename` (ambiguous when names collide), and JRACLOUD-78388 confirms there is no REST mapping from a comment to the attachment it embeds. Consequence for the delete-then-upload implementation:
- "Same filename" lookup retrieves all `fields.attachment[]` entries whose `filename` matches (case-sensitive; Jira filenames are stored verbatim)
- Per OQ-6 ruling: delete ALL matching entries (last-write-wins; no error on multiple matches)
- The delete → upload sequence is **non-atomic**: a concurrent upload between the two steps can produce a duplicate. This is an accepted limitation — the spec MUST document the race and must NOT assert atomicity. BC-3.9.003 will require an EC (edge-case clause) noting the non-atomic race and citing JRACLOUD-96384/-78388.

**`--older-than` on bulk delete (BC-3.9.007 repaired):**

The duration argument uses the existing `src/duration.rs` parser conventions (e.g., `7d`, `2w`, `4h`) — same family as `worklog add --duration`. **[P2-008 retro-correction 2026-07-15: `duration.rs` accepts `w`, `d`, `h`, `m` (minutes) ONLY — no months (`M`); the earlier example `1M` was wrong and is removed.]** The BC must cite `duration.rs` and its accepted unit set. Client-side comparison: filter `fields.attachment[].created` where `(now - created) > duration`. The `created` field is ISO 8601 string — parse with `chrono` (already a transitive dep via `src/cli/issue/changelog.rs` usage).

**`--dry-run` on bulk delete (BC-3.9.010 repaired):**

`--dry-run` with `--older-than` (or when applied to the future `--all` batch-delete variant if that is added): list affected IDs without issuing any DELETE requests. Output: table of `[id, filename, size, created]` rows to stdout; `--output json` shape: `{"dryRun": true, "ids": [str], "attachments": [{id, filename}]}`. No HTTP mutations. Applies only to multi-attachment paths (`--older-than`, future `--all`); `--dry-run` on a single-ID delete is a no-op with a stderr hint ("--dry-run has no effect on single-ID delete; omit the flag").

### R3.3 Delete confirmation gate (ADV-576-P1-004)

**Human ruling (2026-07-15):** `attachment delete` gains the house y/N + `--yes` confirmation gate, mirroring `comment delete` (BC-3.5.002 / BC-3.5.003 precedent), NOT the `--public` upload gate:

- **Single-ID delete (interactive TTY):** `eprint!` the prompt ("Delete attachment <filename> (<id>)? [y/N]") + `stdin read_line`; same DEC-174 `eprint!+read_line` pattern
- **Single-ID delete (non-interactive, `--no-input` or non-TTY):** exit 64 with a `--yes` hint
- **`--yes` flag:** bypasses gate for single-ID delete
- **Bulk delete (`--older-than`):** always requires `--yes` (no interactive prompt for bulk — the gate is mandatory-explicit, same rationale as OQ-4); missing `--yes` → exit 64 with "`--older-than` requires `--yes` to confirm bulk deletion"
- **`--yes` without a gated operation:** silent no-op (DEC-169 leniency)
- **Cancel path JSON shape:** `{"cancelled": true, "deleted": false}` (consistent with comment delete cancel; no `id`/`key` in cancel shape)

**Precedent for F2 spec authors:** BC-3.5.002 (delete endpoint + exit codes), BC-3.5.003 (confirmation gate mechanic), DEC-169 (leniency), DEC-174 (`eprint!+read_line`). Mirror `src/cli/issue/interactions.rs::handle_comment_delete`.

### R3.4 Delete signature confirmed: ID-only (OQ-7 settled)

OQ-7 ruling from Rev 2 is confirmed by adversary pass: `jr issue attachment delete <AID>` takes the attachment ID as a bare positional — no `--issue KEY` required for single delete (the Jira `DELETE /rest/api/3/attachment/{id}` endpoint takes only an attachment ID; the issue key is not part of the API call). The `--issue <KEY> --older-than <duration>` form requires the key for the attachment list lookup. These two forms are mutually exclusive:

- `delete <AID>` — single ID, positional
- `delete --issue <KEY> --older-than <duration>` — bulk by age, requires `--issue KEY`

clap should enforce mutual exclusion between the positional `<AID>` and `--issue`/`--older-than`.

### R3.5 Revised BC estimate

The following new BCs are required beyond the ~27 from Rev 2. They extend Section 3.9; no new section needed.

| New BC | Subject |
|--------|---------|
| BC-3.9.015 | `attachment delete <AID>` interactive confirmation gate: `eprint!+read_line` (DEC-174); non-interactive → exit 64 + `--yes` hint; `--yes` bypasses; cancel shape `{"cancelled": true, "deleted": false}` |
| BC-3.9.016 | `attachment delete --older-than` always requires `--yes` (no interactive prompt for bulk); missing `--yes` → exit 64; `--dry-run` previews without mutating |
| BC-3.9.017 | `attachment upload --replace-existing` same-filename lookup: delete ALL entries with matching filename before uploading (OQ-6 ruling: last-write-wins); non-atomic race with concurrent uploads documented in spec (JRACLOUD-96384/-78388); BC MUST NOT assert atomicity |
| BC-3.9.018 | `attachment upload --replace-existing` when no same-filename attachment exists: upload proceeds without error (idempotent flag) |
| BC-3.9.019 | `attachment delete --older-than <duration>` duration parsing via `src/duration.rs` conventions; `created` ISO 8601 compared client-side via `chrono`; `--output json` bulk-delete shape: `{"deleted": true, "count": N, "ids": [str]}` |
| BC-3.9.020 | `attachment delete --dry-run` (with `--older-than` or future `--all` path): lists affected IDs without mutation; `--output json` shape: `{"dryRun": true, "ids": [str], "attachments": [{id, filename}]}`; `--dry-run` on single-ID delete → stderr hint + exit 0 (no-op) |

**+6 new BCs.** Revised Section 3.9 total: 20 BCs (14 from Rev 2 + 6 new).

**Revised grand total: ~651 + 6 = ~657 individually-bodied BCs.**

Holdout additions (~7 new scenarios, authored in F2 per ruling): delete-gate cancel path; bulk-delete `--yes` missing → exit 64; `--dry-run` bulk preview shape; `--replace-existing` with 0 / 1 / N same-filename hits; `--older-than` duration edge cases; `--replace-existing` non-atomic race documentation check.

### R3.6 Story-shape note

S3 (upload) and S4 (delete) are materially larger after this repair:

- **S3** now owns `--replace-existing` with the non-atomic race documentation obligation (BC-3.9.017, BC-3.9.018) in addition to the core multipart upload (BC-3.9.001–3.9.005)
- **S4** now owns the delete confirmation gate (BC-3.9.015), the `--older-than` + `--dry-run` path (BC-3.9.016, BC-3.9.019, BC-3.9.020), and the bulk `--yes`-required guard

Whether S4 should be split (e.g., S4a single-ID delete + S4b bulk `--older-than`/`--dry-run`) is an **F3 story-decomposition decision** — not resolved at F1. The BC coverage is settled; the story boundary is the implementer's scoping call at F3.

Wave shape and story count (5 stories) are otherwise unchanged from Rev 2. Estimated delivery revised to **7–9 developer-days** (upward from 6–8) to account for the restored scope.

### R3.7 Retro-annotation: 5th function in `src/api/jira/attachments.rs` (NEW-R6-005)

The §1.1 function table in Rev 1 lists four functions. A fifth is required for the delete confirmation gate (BC-3.9.015): the pre-prompt metadata fetch that supplies `filename` for the confirmation message ("Delete attachment `<filename>` (`<id>`)? [y/N]").

| Function | Endpoint | Notes |
|----------|----------|-------|
| `get_attachment_metadata(client, aid)` | `GET /rest/api/3/attachment/{id}` | Returns JSON metadata only (not bytes); confirmed by research §1a — "the attachment itself is not returned"; used by `handle_attachment_delete` before issuing DELETE to populate the confirmation prompt |

The full revised function list for `src/api/jira/attachments.rs` (5 functions): `list_attachments`, `get_attachment_content`, `get_attachment_metadata`, `upload_attachment`, `delete_attachment`. S4 story plan must allocate implementation scope for this function alongside the delete handler.

### R3.8 Orchestrator pattern-extension rulings (adversary pass 2 checkpoint) — FLAG FOR HUMAN REVIEW AT F2

Two rulings made at the adversary-pass-2 checkpoint extend existing house patterns. Both are marked for explicit human confirmation at the F2 spec gate before being encoded in BCs.

#### R3.8a: Multi-positional delete is bulk → `--yes` required (ADV-576-P2-001)

**Ruling (orchestrator, 2026-07-15; FLAG FOR HUMAN REVIEW AT F2):**
`jr issue attachment delete <AID> <AID> ...` with 2 or more positional IDs is treated as a **bulk operation** and requires `--yes`, mirroring the `--older-than` rule (R3.3). A single positional ID keeps the interactive y/N gate; 2+ IDs require the explicit non-interactive flag.

**Rationale:** The house pattern for bulk destructive operations (e.g., `issue edit` with multiple keys, `attachment delete --older-than`) is mandatory-explicit `--yes` — no interactive prompt for bulk, because prompting once for N deletions is misleading about scope. Extending that pattern to multi-positional delete is consistent and prevents accidental mass deletion. The clap variant collapses the positional `<AID>` to `num_args = 1..` and the handler branches on `aids.len()`.

**BC implication:** BC-3.9.015 (delete gate) will need an EC clause: `(EC-3.9.015-1) aids.len() == 1 → interactive gate or non-interactive exit 64; (EC-3.9.015-2) aids.len() >= 2 → `--yes` required, missing → exit 64`. JSON success shape for multi-ID: `{"deleted": true, "count": N, "ids": [str]}` (same as bulk `--older-than`).

#### R3.8b: No destructive call before a pending confirmation gate (ADV-576-P2-003)

**Ruling (orchestrator, 2026-07-15; FLAG FOR HUMAN REVIEW AT F2):**
The `--replace-existing` delete phase (delete same-filename attachments before re-uploading) MUST execute AFTER any pending confirmation gate has been resolved — it may not issue DELETE calls before the user has confirmed (or `--yes` has been supplied). This applies specifically to the interaction between `attachment upload --public --replace-existing`: the `--public` confirmation gate fires first; only after the user confirms (or `--yes` bypasses) does the delete-then-upload sequence proceed.

**Rationale (ADV-576-P2-003):** A destructive HTTP call (DELETE) interleaved before a gate check creates a data-loss window: if the user cancels at the `--public` prompt after the old attachments have already been deleted but before the new upload, the issue is left with no attachments. The invariant "no destructive call precedes any pending confirmation gate" closes this ordering hazard. It is consistent with the existing house invariant for `comment delete` (confirmation before any HTTP mutation).

**Implementation constraint for `handle_attachment_upload`:** the handler ordering must be:
1. Resolve `--public` gate (confirm or `--yes` check) — if present
2. If `--replace-existing`: fetch `fields.attachment[]`, identify same-filename entries (GET, read-only)
3. If `--replace-existing` and gate passed: issue DELETE for each matched attachment
4. Upload new file(s) via multipart POST

Steps 3 and 4 are both mutations; both happen after step 1. The BC for `--replace-existing` (BC-3.9.017) must encode this ordering as an invariant.

> **[PHASE-DOC-RETRO-ANNOTATION 2026-07-15, R9-003 LOW]** The gate-first ordering above (gate → list → delete → upload) was superseded during BC-3.9.017 finalisation. The settled ordering in BC-3.9.017 is **list-first → gate → delete → upload**:
> 1. If `--replace-existing`: fetch `fields.attachment[]`, identify same-filename entries (GET, read-only)
> 2. Resolve `--public` gate — if present; MAY be skipped when step 1 finds zero matches (no destructive work to confirm); prompt CAN display what will be deleted, drawn from step 1 results
> 3. If `--replace-existing` and gate passed: issue DELETE for each matched attachment
> 4. Upload new file(s) via multipart POST
>
> The safety invariant "no destructive call before a pending confirmation gate" is preserved in both orderings — step 3 (DELETE) still follows step 2 (gate) in the settled form. The list-first change is a UX improvement, not a safety regression: it allows the gate to be a no-op when there are no filename matches, and it allows the confirmation prompt to name what will be deleted.

### R3.9 Function inventory additions (pass-3 P3-003 + P3-004)

#### R3.9a: `parse_age_duration` — new function (P3-003)

BC-3.9.019 specifies a dedicated duration parser for `--older-than` with explicit calendar-semantics arithmetic. This is **not** `src/duration.rs` reused directly — `duration.rs` provides **no string→quantity conversion at all** (syntax-validate + format only; it performs no arithmetic). **[P5-007 retro-correction 2026-07-15: the earlier phrasing "converts strings to seconds for worklog display" was wrong — `duration.rs` is a syntax-validate + format-only module with no arithmetic; `parse_age_duration` owns all arithmetic.]** The new function owns its own arithmetic:

| Aspect | Detail |
|--------|--------|
| **Signature** | `parse_age_duration(s: &str) -> Result<chrono::Duration, JrError>` |
| **Semantics** | `w` = 7 × 24 h; `d` = 24 h; `h` = 1 h; `m` = 1 min (identical unit set to `duration.rs`; no month unit — P2-008 correction applies here too) |
| **Syntax style** | Mirrors `duration.rs` family (e.g., `7d`, `2w`, `4h`, `30m`; no whitespace between value and unit required) — cite `duration.rs` in the rustdoc for the convention reference, but call into `parse_age_duration`, not `duration.rs`, at the `--older-than` call site |
| **Location** | Implementer's choice at S4: either inline in `src/cli/issue/attachments.rs` (private helper) or as a sibling `pub(crate) fn` in `src/duration.rs` if the calendar-semantics variant is deemed broadly reusable. The function inventory for `src/api/jira/attachments.rs` is NOT affected — this is a CLI-layer concern |
| **Error** | Unknown unit or malformed input → `JrError::UserError` with a message citing the accepted units (`w`, `d`, `h`, `m`); mirrors `duration.rs` error style |

**S4 story plan note:** allocate scope for `parse_age_duration` alongside the `--older-than` handler path. If placed in `src/duration.rs`, add `"src/duration.rs"` to `.cargo/mutants.toml` `examine_globs` (it is currently absent — the `parse_age_duration` branch logic is HIGH-value for mutation testing).

#### R3.9b: Single `--id` download pinned to metadata-GET-first (P3-004)

The single-file download flow (`attachment download <KEY> --id <AID>`) is pinned to **metadata-GET-first**: call `get_attachment_metadata(client, aid)` (recorded in R3.7) to retrieve `filename`, `mimeType`, `size`, and `content` URL before streaming the file. This allows the handler to:
- Derive the default output filename (`<sha1>_<sanitized-basename>`) without a separate list call
- Emit a useful progress/confirmation line to stderr before the download begins

**No new function needed** — `get_attachment_metadata` from R3.7 is the sole addition. The S2 story plan must invoke `get_attachment_metadata` as the first step of `handle_attachment_download` when `--id` is supplied, then stream via `get_attachment_content`. The revised function call sequence for single `--id` download is: `get_attachment_metadata` → path construction + overwrite check → `get_attachment_content` (streaming write).

### R3.10 Single `--id` download filename convention (P4-001 ruling)

**Ruling (2026-07-15):** The default output filename for a single `--id` download is the **bare sanitized basename** — no SHA-1 prefix. The SHA-1 `<sha1>_<sanitized-basename>` convention from BC-2.7.010 applies to **batch-only** paths (`--all`, `--newest N`). The single-vs-batch asymmetry is deliberate.

| Mode | Default filename | Rationale |
|------|-----------------|-----------|
| `download --id <AID>` | `<sanitized-basename>` | Peer tool convention (unanimous across `gh`, `curl`, browser downloads); a user downloading one known file expects the bare name, not a hash prefix |
| `download --all` / `--newest N` | `<sha1>_<sanitized-basename>` | Batch idempotency: SHA-1 prefix prevents silent overwrite on re-run when two attachments share a filename; also prevents collision between same-name attachments on different issues |

**Degenerate-name fallback:** if the sanitized basename is empty (e.g., filename was entirely path-separators or control characters and nothing survives sanitization), fall back to the attachment ID as the filename (`<aid>` for single; `<sha1>_<aid>` for batch). This ensures the output path is always non-empty and deterministic.

**BC-2.7.010 scope correction:** BC-2.7.010 as recorded in Rev 1 states "default output path is `<sha1>_<sanitized-basename>`" without distinguishing single vs. batch. The F2 spec must split this into two sub-clauses: `(EC-2.7.010-1) single --id → bare sanitized basename (+ degenerate fallback to AID)` and `(EC-2.7.010-2) batch → <sha1>_<sanitized-basename>`. BC-2.7.010 total BC count is unchanged; only its invariant text is refined.

### R3.11 EOF behavior reversal for confirmation gates (P5-001) — FLAG FOR HUMAN REVIEW AT F2

**Ruling reversal (2026-07-15, pass-5):** The P2-era direction for `delete` and `--public` gates stated EOF=cancel-exit-0 by analogy with what was believed to be `dialoguer::Confirm` behavior. That premise was **FALSE**: `comment delete` uses `eprint!+read_line` (DEC-174), not `dialoguer`, and maps EOF → `Interrupted` exit 130 per EC-3.5.003-3 (pinned by VP-577-030).

**Settled ruling:** all attachment confirmation gates mirror the sibling (`handle_comment_delete`) exactly:

| Input at the `[y/N]` prompt | Behavior |
|-----------------------------|----------|
| `y` / `Y` (Enter) | proceed |
| Anything else / bare Enter | cancel → exit 0; JSON: `{"cancelled": true, ...}` |
| EOF (`read_line` returns `Ok(0)`) | `JrError::Interrupted` → exit 130 |

The distinction between empty-Enter (cancel, exit 0) and EOF (exit 130) is load-bearing for scripting: a shell pipe closing unexpectedly is an interruption, not a user cancel. EC-3.5.003-3 is the existing precedent; the F2 spec for BC-3.9.015 (delete gate) and BC-3.9.014 (`--public` gate) MUST reproduce this three-way branch verbatim.

**Scope of the reversal:** R3.8a/b do not carry explicit EOF wording (checked — no annotation needed there). The affected design inputs are the `[y/N]` gate sections in R3.3 (delete gate) and SQ-7 / OQ-8 (`--public` gate). Neither states EOF=cancel-exit-0 explicitly in the file, so no retro-annotation to those sections is required; this R3.11 note is the sole correction record.

**PHASE-DOC-RETRO-ANNOTATION (P14-001, 2026-07-16):** The claim "Neither states EOF=cancel-exit-0 explicitly in the file" was **FALSE** at the time of this ruling. BC-3.9.003 (the `--public` gate BC, in the F2 spec written in the same session that produced this ruling) DID explicitly state "any other input (including empty/EOF) → exit 0" — meaning EOF was explicitly stated to produce exit 0 (cancel). This ruling should have noted that BC-3.9.003 required a retro-annotation; it did not. Corrected by P14-001: BC-3.9.003 was updated to the correct three-way branch (EOF → exit 130), and this annotation records that R3.11's "sole correction record" claim was incomplete. The retro-annotation obligation that was missed in the original ruling is now satisfied by this note.

**Implementation note for F2 spec authors:** the `read_line` arm that returns `Ok(0)` (zero bytes read = EOF) must map to `return Err(JrError::Interrupted)`, identical to the pattern in `src/cli/issue/interactions.rs::handle_comment_delete`. The `Interrupted` variant already carries exit code 130 via `JrError::exit_code()`.
