# Secondary Adversarial Review — SOH-ATTACHMENTS-1

**Reviewer:** Secondary adversary (fresh-context, no prior review artifacts read)  
**Scope:** `src/cli/issue/attachments.rs`, `src/api/jira/attachments.rs`, `src/api/jsm/attachments.rs`, `src/cli/mod.rs` (attachment clap definitions), `tests/attachment_{list,download,upload,delete,jsm}.rs`  
**Delta:** `e33624c1~1..db207b81`  
**Branch:** `develop` @ `db207b81`  
**Reference:** bc-2-issue-read.md §2.7, bc-3-issue-write.md §3.9, cross-cutting.md BC-X.8.010  

---

## Lens

This review took a different angle from a checklist walk: async/cancellation hazards, resource lifecycle (fd/tempfile leaks), API misuse (reqwest multipart/streaming), unicode/OsStr edge cases, TOCTOU, JSON schema stability, and seams between the three source files.

---

## Findings

### CRITICAL — 0

None.

---

### HIGH — 0

None.

---

### MEDIUM — 0

None.

---

### LOW — 4

#### L1 — Temp file leaked on Ctrl+C / future cancellation during streaming download

**File/Symbol:** `src/cli/issue/attachments.rs::stream_to_file` (~line 680)  
**Severity:** LOW  
**Description:**  
`stream_to_file` creates `tmp_<16 random hex chars>` in the output directory before streaming. The cleanup path (`tokio::fs::remove_file(&tmp_path).await`) at the bottom of the function fires only when the inner async block returns `Err`. When the user presses Ctrl+C, `main.rs` handles it via:
```rust
tokio::select! {
    result = main_task => result,
    _ = tokio::signal::ctrl_c() => {
        eprintln!("\nInterrupted");
        std::process::exit(130);
    }
}
```
`std::process::exit(130)` fires before the `stream_to_file` future resolves. The future is dropped — neither the inner async block's error path nor the outer cleanup code at lines 750-753 ever executes. The `tmp_XXXXXXXXXXXXXXXX` partial file is left on disk.

For repeated interrupted downloads (large files, slow connections), these files accumulate silently in the user's chosen output directory. There is no automated cleanup mechanism.

**No data corruption risk.** The file has a randomized name (`tmp_` prefix with 16 random hex digits) that will not collide with legitimate output files or future downloads.

**Suggested fix:**  
Introduce a synchronous `TmpFileGuard(PathBuf)` with a `Drop` impl that calls `std::fs::remove_file` if the file still exists. Since `drop` is synchronous and `std::process::exit` calls destructors for stack frames in progress (within the same thread), this guard would fire on both the normal error path and the `exit(130)` path.

```rust
struct TmpFileGuard(std::path::PathBuf);
impl Drop for TmpFileGuard {
    fn drop(&mut self) { let _ = std::fs::remove_file(&self.0); }
}
```

Alternatively, document the behavior (e.g., in `--help` for `download`) so users know to `rm tmp_*` after a Ctrl+C.

---

#### L2 — SEC-576-004 `safe_name` guard duplicated across two API files

**File/Symbol:** `src/api/jira/attachments.rs::upload_attachments` (inline guard), `src/api/jsm/attachments.rs::attach_temporary_file` (inline guard)  
**Severity:** LOW  
**Description:**  
The SEC-576-004 CRLF/NUL/double-quote/backslash `Content-Disposition` guard is copy-pasted identically into both functions:
```rust
let safe_name: String = raw_name.chars().map(|c| {
    if matches!(c, '\r' | '\n' | '\0' | '"' | '\\') { '_' } else { c }
}).collect();
```
This guard was extended twice during F5 review (F5-R1-006: added `"`, F5-R2-002: added `\`), demonstrating that both copies need updating in lockstep. Each file carries its own unit-test mirror of the guard. The CLAUDE.md gotcha entry for SEC-576-004 documents this as a single logical requirement.

If a future reviewer adds a character to one guard but not the other, the two upload paths diverge silently on a security-relevant sanitization invariant.

**Suggested fix:**  
Extract to a shared pure function, e.g., `fn safe_content_disposition_filename(raw: &str) -> String` in `src/cli/issue/attachments.rs` (alongside the already-public `display_sanitize_filename`) or in a dedicated `src/cli/issue/attachment_guards.rs` module. Both call sites import the single function; the unit tests can move to one location.

---

#### L3 — `post_request_attachment` (JSM step-2) does not retry on HTTP 429

**File/Symbol:** `src/api/jsm/attachments.rs::post_request_attachment` (lines 292-392)  
**Severity:** LOW  
**Description:**  
The JSM step-1 path (`attach_temporary_file`) retries up to 3 times with Retry-After parsing on 429. The platform upload path (`upload_attachments` in `src/api/jira/attachments.rs`) does the same. Step-2 (`post_request_attachment`) issues a simple JSON POST with a clonable / trivially-rebuildable body — the ADR-0017 multipart-body-not-clonable constraint does not apply here. Under rate limiting, step-2 fails immediately with API error 429 while both other upload paths would have retried.

The consequence: when step-2 hits 429, the temporary attachment IDs uploaded in step-1 are left dangling (they expire on Atlassian's side). The user must re-run the entire upload manually.

BC-3.9.006 specifies the step-2 failure taxonomy (401/403/4xx/5xx) but does not explicitly exclude 429 from retry; the omission is a spec gap. The RETRY_HINT text ("Try the upload again") documents manual-retry intent but does not prohibit automated retry.

**Suggested fix:**  
Wrap `post_request_attachment`'s request in a retry loop identical to `attach_temporary_file`'s (lines 82-129): `for attempt in 0..=MAX_RETRIES`, check `status == 429 && attempt < MAX_RETRIES`, sleep Retry-After, rebuild the `serde_json::json!` body, retry.

---

#### L4 — `batch_path_is_within_dir` fail-open when canonicalization errors

**File/Symbol:** `src/cli/issue/attachments.rs::batch_path_is_within_dir` (line 562), call site in `handle_batch_download` (lines 1036-1055)  
**Severity:** LOW  
**Description:**  
When `canonicalize()` fails (e.g., the parent directory was removed between the pre-flight check and the per-attachment download iteration), the function returns `Err`. The call site's `Err(e)` arm emits a warning and continues the download without the containment check:

```rust
Err(e) => {
    eprintln!(
        "warning: containment check skipped for attachment {} \
         — could not canonicalize path: {e}.",
        att.id
    );
    // proceeds
}
```

This is documented as SEC-F5-001 fail-open. In isolation it is safe because `compute_default_output_path` only ever produces a flat path component (`<sha1>_<sanitized>`) with no subdirectory separator. No reachable code path today can produce a path that starts with `..` or an absolute root after sanitization. The containment check is genuinely defense-in-depth.

The concern is a future change: if `compute_default_output_path` ever gains sub-directory logic (the function's rustdoc explicitly anticipates this), the fail-open becomes a real weakness. The comment at the call site acknowledges this — it is documented as F5-R3-002. Noted for awareness; no action required unless `compute_default_output_path` gains sub-directory logic.

---

### INFO — 3

#### I1 — `std::process::exit(1)` in `handle_batch_download` after partial failure

**File/Symbol:** `src/cli/issue/attachments.rs::handle_batch_download` (line 1127)  
**Severity:** INFO  
**Description:**  
After a partial or total batch-download failure, the function calls `std::process::exit(1)` directly to avoid routing through `main.rs`'s error printer (which would emit a spurious "Error: API error (1): ..." line to stderr). This abruptly terminates the tokio runtime. All async work for the batch is already complete at this point (all downloads and the manifest/summary output have been written), so there are no in-flight futures to interrupt. The pattern is used in the same way in other parts of this codebase and is documented with a comment.

No actionable finding; noted for completeness.

---

#### I2 — Redundant `Content-Type` header in `post_request_attachment`

**File/Symbol:** `src/api/jsm/attachments.rs:315-316`  
**Severity:** INFO  
**Description:**  
```rust
.header("Content-Type", "application/json")
.json(&body)
```
`reqwest`'s `.json()` method sets `Content-Type: application/json` implicitly. The explicit `.header(...)` call is redundant. reqwest's `HeaderMap` permits multiple values for the same header name, and Jira's API is not sensitive to the duplicate, so this is harmless but is dead code.

**Suggested fix:** Remove the `.header("Content-Type", "application/json")` line.

---

#### I3 — `glob_inner` recursion is unbounded on adversarial patterns

**File/Symbol:** `src/cli/issue/attachments.rs::glob_inner` (line 92)  
**Severity:** INFO  
**Description:**  
`glob_inner` is a recursive descent glob matcher. A pattern with many consecutive `*` wildcards (e.g., `*a*a*a*a*a*...*`) can exhibit O(2^n) call stack depth when matched against a long non-matching string. Since both the pattern (from `--filter mime=<PATTERN>`) and the input (MIME types from the server response) are user-provided or server-provided, neither can be forced by a remote actor without user cooperation. In practice, MIME types are short (e.g., `application/json`), so this is not a real risk in any expected scenario.

No action required. Noted in case the glob matcher is ever extended to handle attachment filenames from a server that returns very long values.

---

## Seam Analysis

### `src/api/jira/attachments.rs` ↔ `src/api/jsm/attachments.rs`

The interface is clean: `attach_temporary_file` returns a plain `String` (the `temporaryAttachmentId`), and `post_request_attachment` takes a `&[String]` slice. No shared mutable state. The `curate_jsm_attachment_entry` function correctly handles the shape-divergence between the servicedeskapi `AttachmentDTO` and the platform `AttachmentObject`, with documented graceful fallbacks on every field per BC-3.9.007.

One coupling note: `AttachmentObject.self_url` is a required non-Optional `String` (annotated `#[serde(rename = "self")]`). The JSM curation path populates it via `_links.self` with an `unwrap_or_default()` fallback (→ `""`). The platform deserialization path (`list_attachments` via `IssueAttachmentFields`) would fail for any attachment missing the Jira `"self"` field. In practice, Jira always returns `"self"`. This is a theoretical gap, not an observed failure.

### `src/cli/issue/attachments.rs` ↔ the two API files

The handler (`attachments.rs`) correctly sequences the JSM two-step upload: all DELETEs before any POST (VP-576-003), stale-ID self-heal at most once per command invocation (`stale_healed: bool`), and explicit `None` → `JrError::UserError` mapping after the retry to provide exit-64 (not the pass-through ApiError exit-1 that a bare `?` would produce). The retry-result `downcast` pattern at line 1889 (`match e.downcast::<JrError>()`) correctly consumes the error, distinguishing the `404` case from all others.

### Clap definitions (`src/cli/mod.rs`) ↔ handlers

The clap ArgGroup constraints correctly enforce the spec:
- `selector` group (required, `--id | --all | --newest`) prevents dispatcher ambiguity.
- `--filter` conflicts with `--id`: the single-download path never calls `parse_filters`.
- `--dry-run` requires `--replace-existing`: the `dry_run=true` branch in `handle_attachment_upload` and `handle_attachment_upload_jsm` will always see `replace_existing=true`.
- The `Delete` group's `delete_target` with `multiple=true` and `required=true` correctly rejects bare `jr issue attachment delete` (no AID, no `--issue`).

No async/clap dispatch mismatches observed.

---

## Cancellation Hazard Summary

The most significant async/cancellation hazard is the temp file leak (L1). All other async operations in the delta are fire-and-forget HTTP calls that clean up via reqwest's own teardown on future drop. The batch-download failure uses `std::process::exit(1)` which avoids the need for async cleanup after the download loop completes.

---

## JSON Schema Stability

All five subcommand output paths comply with the JSON render invariant (#526): every `--output json` path routes through `output::render_json`. No direct `serde_json::to_string_pretty` or compact-print calls were found.

The `AttachmentDownloadEntry` and `DownloadManifest` structs use `#[derive(serde::Serialize)]` with field names as-is (no rename_all); key names are stable. The `serialize_attachment_curated` function uses `BTreeMap` for alphabetical key ordering — stable across invocations and Rust versions. The delete-command JSON payloads use `serde_json::json!` macros; key ordering is insertion-order (deterministic within the macro call).

---

## Verdict

**PASS** — zero CRITICAL, zero HIGH findings.

The implementation is security-sound on the attack surfaces that matter most: CWE-22 (5-step sanitization + containment check), CWE-116 (display sanitization), CWE-93 (Content-Disposition CRLF/NUL/quote/backslash guard on both upload paths), GHSA-9857-6MW7-FQ2M (correct CDN redirect behavior), atomic temp-file + rename pattern, and the JSM two-step flow with stale-ID self-heal.

The LOW findings are quality-of-life or defense-in-depth observations. L2 (guard duplication) carries the highest refactoring value since it has already demonstrated drift potential during F5.

---

## Finding Counts

| Severity | Count |
|----------|-------|
| CRITICAL | 0     |
| HIGH     | 0     |
| MEDIUM   | 0     |
| LOW      | 4     |
| INFO     | 3     |
| **Total**| **7** |
