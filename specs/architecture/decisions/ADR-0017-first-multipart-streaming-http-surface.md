---
document_type: adr
adr_id: ADR-0017
status: Accepted
date: 2026-07-15
subsystems_affected: ["SS-03", "SS-09"]
supersedes: null
superseded_by: null
related: ["ADR-0001", "ADR-0003"]
---

# ADR-0017: First multipart/streaming HTTP surface: reqwest multipart+stream features + tokio-util direct dependency

## Status

**Accepted** (2026-07-15). Gate: DEC-179, item 7 of the F1 SOH-ATTACHMENTS-1 dependency gate.

## Context

As of v0.6.0-dev.10, `jr` uses reqwest with the feature set `["json", "rustls"]` only
(`src/api/client.rs`, `Cargo.toml`). No multipart or streaming support is present. The
current `JiraClient` sends JSON request bodies and receives JSON responses — both are fully
buffered in memory.

The SOH-ATTACHMENTS-1 feature (issue #576) requires two new HTTP surface capabilities:

1. **Attachment upload** — Jira's platform REST API (`POST /rest/api/3/issue/{key}/attachments`)
   and the JSM equivalent (`POST /rest/servicedeskapi/servicedesk/{id}/attachTemporaryFile`)
   accept only `multipart/form-data` payloads. The Jira Cloud API rejects `application/json`
   on these endpoints; there is no alternative encoding. reqwest's `multipart` feature is the
   standard Rust mechanism for building `multipart/form-data` bodies.

2. **Attachment download** — Jira serves attachment binary content from pre-signed media URLs.
   Attachments can reach very large sizes on instances with permissive limits
   (Jira Cloud attachment limits are instance-configured and site/plan-dependent; the research
   verdict is inconclusive across sources — do not hard-code a figure; DEC-179 ruling 4).
   Buffering the entire body in memory (`bytes()`) before writing to disk is unsafe at those
   sizes; streaming (`bytes_stream()`) and writing chunks incrementally is required. The
   `stream` reqwest feature exposes `Response::bytes_stream()` as a `Stream<Item = Bytes>`.

`tokio-util` (0.7.x) is already present in `Cargo.lock` as a transitive dependency. The
`ReaderStream` adapter in `tokio-util::io` bridges a standard `AsyncRead` (e.g. a
`tokio::fs::File`) to the `Stream<Item = Bytes>` type that reqwest expects for a streaming
multipart `Part`. Promoting it to a direct dependency avoids relying on transitive version
resolution, which can silently change when other deps update.

A pre-implementation supply-chain audit was conducted on 2026-07-15 against the feature additions
(research file: `.factory/research/issue-576-attachments-api-2026-07-15.md`, Part 2 item 8):
`cargo deny advisories` and `cargo audit` both reported clean.

An additional load-bearing behavior was confirmed during the same audit: **reqwest 0.13's default
redirect policy strips the `Authorization` header on cross-host redirects** (corroborated by
GHSA-9857-6MW7-FQ2M's mitigation language). This is directly relevant to the attachment download
path because Jira issues a redirect from the `GET /rest/api/3/attachment/content/{id}` content
endpoint to a pre-signed media URL on a different host (`media.atlassian.com` or equivalent).
The download implementation must follow the pre-signed URL directly — not pass an `Authorization`
header to the media host — and must handle the redirect-then-download flow correctly.

## Decision

Enable the reqwest `multipart` and `stream` features in `Cargo.toml`. Promote `tokio-util` to a
direct dependency at `^0.7` with the `io-util` feature enabled.

Specifically:

1. **reqwest `multipart` feature** — provides `reqwest::multipart::{Form, Part}` for building
   `multipart/form-data` request bodies. Required for upload paths on both the platform REST
   API and the JSM servicedeskapi.

2. **reqwest `stream` feature** — exposes `Response::bytes_stream()` returning a
   `impl Stream<Item = reqwest::Result<Bytes>>`. Required for streaming large attachment
   downloads to disk without full-body buffering.

3. **`tokio-util` direct dependency (`^0.7`, `features = ["io-util"]`)** — promotes the
   already-transitive crate to a direct dependency for `tokio_util::io::ReaderStream`. This
   converts a `tokio::fs::File` (or any `AsyncRead`) into a `Stream<Item = Bytes>` compatible
   with a reqwest multipart `Part::stream()`. No new crate enters the supply chain — only
   the version resolution becomes explicit. **Feature note (P18-I2)**: the `io-util` feature
   transitively enables the `io` feature; `io` alone is the minimal feature flag for
   `ReaderStream`. An implementer may declare `features = ["io"]` instead — `io-util` is
   sufficient and is the conservative explicit choice.

Cargo.toml is NOT modified by this ADR delivery — the dependency additions are deferred to the
Story 3 delivery slot per the SOH-ATTACHMENTS-1 wave schedule.

## Rationale

**Why reqwest `multipart` + `stream`?** They are the canonical upstream features for their
respective use cases and are already shipped as part of reqwest 0.12/0.13's feature surface.
Enabling them adds no new transitive crates. The alternative (hand-rolled multipart encoding)
is rejected — see Alternatives Considered.

**Why tokio-util direct dep?** `ReaderStream` is the only idiomatic bridge between
`AsyncRead` (tokio file I/O) and the `Stream<Item = Bytes>` type accepted by reqwest
`Part::stream()`. Without it, an upload implementation must either buffer the entire file
in memory (defeating the purpose of streaming) or re-implement stream bridging. Relying on
the transitive path is fragile: other deps can update and change the resolved version
without warning, potentially introducing incompatibilities in the `io-util` API.

**Why `^0.7`?** tokio-util 0.7.x is the semver-stable series compatible with tokio 1.x.
Cargo.lock already pins a 0.7.x patch version transitively; promoting to `^0.7` merely
makes the dependency explicit.

**Supply-chain invariant (ADR-0001 / ADR-0003 alignment):** The thin-client architecture
(ADR-0001) mandates a single `JiraClient` using a single `reqwest::Client`. Feature additions
to reqwest are strictly additive — they do not introduce new HTTP clients, new TLS stacks,
or new connection management layers. reqwest's `multipart` and `stream` features are compile-time
gates on code paths within the same crate version that is already present; they do not pull in
additional TLS backends or change the `rustls` selection made in ADR-0003.

**X-Atlassian-Token invariant (upload-path):** Jira's XSRF protection requires
`X-Atlassian-Token: no-check` on attachment upload endpoints. This is a per-request header
requirement, not a client-level configuration; it will be set at the call site in
`src/api/jira/issues.rs` (or a new `attachments.rs`) during Story 3 delivery. It is noted
here because it is the primary non-obvious invariant of the multipart upload path and must not
be omitted.

## Consequences

### Positive

- Attachment upload to both the Jira platform API and the JSM servicedesk API becomes
  implementable without a new HTTP client or an incompatible encoding.
- Large file downloads can be streamed chunk-by-chunk, bounding memory usage to one chunk
  rather than the full file size.
- No new crate enters the dependency graph; `cargo deny` advisory state is maintained.
- The `tokio-util` version is locked explicitly, eliminating silent transitive drift.

### Negative / Trade-offs

- Binary size will increase by a small amount due to the multipart encoder and stream
  combinator code being compiled in. The exact delta will be measured at S3 delivery against
  the 7.09 MB v0.6.0-dev.10 binary-size baseline (established at the F1 gate, DEC-179;
  noted in the task brief — not in the research file); it is expected to be small.
- `cargo deny` must be re-run after Cargo.toml edits to confirm no advisory or license
  regression from the explicit tokio-util promotion.

### Status as of 2026-07-15

Accepted at the F1 gate (DEC-179 item 7). Cargo.toml changes are deferred to Story 3 of the
SOH-ATTACHMENTS-1 wave. The decision is binding; the implementation is not yet delivered.

## Alternatives Considered

- **Option hand-rolled multipart:** Build the `multipart/form-data` body manually by
  constructing the MIME boundary, encoding part headers, and concatenating body bytes.
  Rejected because this is error-prone (escaping, boundary collision, CRLF line endings are
  all specified by RFC 2046 and easy to get subtly wrong), requires ongoing maintenance, and
  reinvents a well-tested wheel already present in reqwest's own feature surface.

- **Option buffer-full-file-in-memory for downloads:** Call `response.bytes().await?` for
  attachment download and write the collected bytes to disk. Rejected because Jira Cloud
  attachment size limits are instance-configured and potentially very large (research verdict:
  inconclusive; limits in the low-to-mid GB range are documented across sources); buffering a
  multi-hundred-MB blob in the CLI process is unsafe and would cause OOM on constrained hosts.
  The streaming path is the only safe default.

- **Option separate HTTP client for uploads:** Use a second `reqwest::Client` (or an
  entirely different crate such as `hyper` or `surf`) for attachment I/O to avoid touching
  the existing `JiraClient`. Rejected because it violates the single-client thin-client
  architecture (ADR-0001, ADR-0003): introduces a second TLS stack instance, a second
  connection pool, and splits the authentication header responsibility across two codepaths.
  The additive reqwest feature approach keeps all HTTP traffic through the single
  `JiraClient`.

## Source / Origin

- Research and supply-chain audit: `.factory/research/issue-576-attachments-api-2026-07-15.md`
  Part 2 item 8 — `cargo deny` advisories clean, `cargo audit` (347 deps) clean, no
  RustSec/GHSA advisory against reqwest 0.13.x or tokio-util 0.7.x.
- Gate decision: DEC-179 item 7 (F1 gate for SOH-ATTACHMENTS-1).
- Related ADRs: ADR-0001 (thin client — single JiraClient), ADR-0003 (reqwest + rustls).
- Cross-host redirect strip behavior: GHSA-9857-6MW7-FQ2M (a `gix-transport` advisory, NOT a
  reqwest advisory; its mitigation language — reqwest "compares host strings and strips sensitive
  headers on cross-domain redirects" — independently corroborates reqwest's default policy.
  reqwest 0.13 itself has no RustSec/GHSA advisory as of the 2026-07-15 audit).
- Jira Cloud attachment upload API: `POST /rest/api/3/issue/{key}/attachments` and
  `POST /rest/servicedeskapi/servicedesk/{id}/attachTemporaryFile`.
- `X-Atlassian-Token: no-check` requirement: Atlassian REST API documentation (XSRF
  protection header for file upload endpoints).
