---
document_type: adr
adr_id: ADR-0017
status: Accepted
date: 2026-07-15
amended: 2026-07-18
subsystems_affected: ["SS-03", "SS-09"]
supersedes: null
superseded_by: null
related: ["ADR-0001", "ADR-0003"]
---

# ADR-0017: First multipart/streaming HTTP surface: reqwest multipart+stream features + tokio-util direct dependency

## Status

**Accepted** (2026-07-15). Gate: DEC-179, item 7 of the F1 SOH-ATTACHMENTS-1 dependency gate.
**Amended** (2026-07-17): Cargo.toml delivery split across S-576-2 and S-576-3 delivery slots per adversarial finding P1-010, F3 pass 1. See § Decision amendment below.
**Amended** (2026-07-18): Authorized-dependency clause added for the `sha1` crate (RustCrypto) in the S-576-2 delivery slot; "No new crate" claims scoped to the HTTP surface (reqwest features + tokio-util). See § Authorized Dependencies. Traces P26-001, F3 pass 26.

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
   with a reqwest multipart `Part::stream()`. No new crate enters the **HTTP supply chain** — only
   the version resolution becomes explicit. (This claim is scoped to the reqwest/tokio-util HTTP
   surface; the `sha1` crate authorized for S-576-2 is governed by § Authorized Dependencies.) **Feature note (P18-I2)**: the `io-util` feature
   transitively enables the `io` feature; `io` alone is the minimal feature flag for
   `ReaderStream`. An implementer may declare `features = ["io"]` instead — `io-util` is
   sufficient and is the conservative explicit choice.

Cargo.toml delivery is **split across two story slots** per the earliest-consumer principle
(DEC-184 R3.13; amended 2026-07-17, adversarial finding P1-010, F3 pass 1):

- **S-576-2 delivery slot (earliest consumer):** reqwest `stream` feature only — required by
  `Response::bytes_stream()` in `get_attachment_content` for streaming large downloads. `tokio-util`
  is NOT needed for the download path.
- **S-576-3 delivery slot:** reqwest `multipart` feature + `tokio-util = { version = "^0.7",
  features = ["io-util"] }` direct dependency — both required for the upload path
  (`src/api/jira/attachments.rs` multipart form encoding and `ReaderStream` adapter).

The original text deferred all three Cargo.toml changes to Story 3. That was corrected because
S-576-2 (`depends_on: ["S-576-1"]`; independent of S-576-3) hard-requires `stream` for OOM-safe streaming (BC-2.7.007) and is
independent of S-576-3; making S-576-2 wait on S-576-3 would chain download behind upload without
architectural justification.

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
`src/api/jira/attachments.rs` during Story 3 delivery (call-site corrected per CONS-576-002, P30-003). It is noted
here because it is the primary non-obvious invariant of the multipart upload path and must not
be omitted.

## Consequences

### Positive

- Attachment upload to both the Jira platform API and the JSM servicedesk API becomes
  implementable without a new HTTP client or an incompatible encoding.
- Large file downloads can be streamed chunk-by-chunk, bounding memory usage to one chunk
  rather than the full file size.
- No new crate enters the **HTTP dependency graph** for this decision's scope (reqwest features + tokio-util promotion); `cargo deny` advisory state is maintained. (The `sha1` crate authorized in § Authorized Dependencies is outside this HTTP-surface scope.)
- The `tokio-util` version is locked explicitly, eliminating silent transitive drift.

### Negative / Trade-offs

- Binary size will increase by a small amount due to the multipart encoder and stream
  combinator code being compiled in. The exact delta will be measured at S3 delivery against
  the 7.09 MB v0.6.0-dev.10 binary-size baseline (established at the F1 gate, DEC-179;
  noted in the task brief — not in the research file); it is expected to be small.
- `cargo deny` must be re-run after Cargo.toml edits to confirm no advisory or license
  regression from the explicit tokio-util promotion.

### Status as of 2026-07-15 (original)

Accepted at the F1 gate (DEC-179 item 7). Cargo.toml changes were deferred to Story 3 of the
SOH-ATTACHMENTS-1 wave. The decision was binding; the implementation was not yet delivered.

### Status as of 2026-07-17 (amendment — P1-010, F3 pass 1)

Cargo.toml delivery split: reqwest `stream` feature ships with S-576-2 (earliest consumer);
reqwest `multipart` + `tokio-util ^0.7 io-util` ship with S-576-3. The core decision (enable
both reqwest features + promote tokio-util) is unchanged. Only the delivery slot allocation is
amended. Implementation not yet delivered in either slot.

2026-07-18: P8-003 — stale depends_on parenthetical corrected (S-576-2 depends on S-576-1, not []); Cargo split unchanged.
2026-07-18: P26-001 — authorized-dependency clause added for the `sha1` crate (RustCrypto); "No new crate" claims scoped to HTTP surface. See § Authorized Dependencies.

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

## Authorized Dependencies

*(Amended 2026-07-18; traces P26-001, F3 pass 26)*

### `sha1` — RustCrypto SHA-1 digest crate

**Crate:** `sha1` (crates.io: [sha1](https://crates.io/crates/sha1), RustCrypto/hashes monorepo)
**Version constraint:** `^0.10`
**License:** MIT OR Apache-2.0 — passes `cargo deny` license policy.
**Delivery slot:** S-576-2 (earliest consumer; see § Decision above).
**Triggering requirement:** BC-2.7.010 mandates a 40-hex-character SHA-1 digest prefix on the default output filename for every attachment in a batch download (`jr issue attachments get <KEY>`). No SHA-1 implementation is available in Rust `std` or in any crate already present in `Cargo.toml`/`Cargo.lock` as of v0.6.0-dev.10.

**Transitive footprint:** The `sha1 ^0.10` crate adds `digest` (trait interface shared across RustCrypto) and `cpufeatures` (runtime CPU-capability detection for hardware-accelerated paths on x86/aarch64). Both are small and have no further transitive dependencies of note.

**Non-cryptographic use — SHA-1 collision-resistance is NOT required:**
SHA-1 is cryptographically broken (practical chosen-prefix collision attacks demonstrated by SHAttered, 2017). This use is **non-cryptographic**: the 40-hex prefix serves as a stable, deterministic, human-readable path component that distinguishes attachments with identical filenames in a single batch. Collision resistance against an adversary is irrelevant — the sole requirement is uniqueness across a typical Jira issue attachment set (typically ≤100 items; attachment IDs are Jira-server-assigned UUIDs). **Do NOT "upgrade" this to SHA-256 or any other algorithm** — doing so would change the 40-hex format, breaking BC-2.7.010's format pin and all downstream tooling relying on the documented path shape. If a future requirement does need cryptographic strength, that warrants a new ADR, not a silent algorithm change here.

**cargo deny obligation:** After `sha1` is added to `Cargo.toml` in the S-576-2 delivery commit, `cargo deny check` must be re-run and reported clean before the PR is merged. Any advisory against the selected `sha1` version must be resolved before merge.

**Selection rationale vs. alternatives:**
`sha1_smol` (a no-std, single-file SHA-1) was considered. It has fewer transitive dependencies but is less actively maintained and has had fewer security eyes than the RustCrypto ecosystem. Given that `digest` and `cpufeatures` are already likely in the transitive tree via other RustCrypto crates (e.g., `ring` or `sha2` if present), the RustCrypto `sha1` crate is preferred for ecosystem coherence and maintenance assurance.

### Status as of 2026-07-18 (amendment — P26-001, F3 pass 26)

`sha1` (RustCrypto `^0.10`) authorized for S-576-2. The "No new crate" claims in § Decision (tokio-util paragraph) and § Consequences are scoped to the HTTP surface only. The `sha1` dependency for the BC-2.7.010 path-prefix requirement is governed by this authorized-dependency clause, not by those claims. Implementation not yet delivered.

---

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
