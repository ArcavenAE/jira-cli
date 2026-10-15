# rustls advisory triage - 2026-10-15 (maintenance sweep)

Scope: `cargo deny check advisories` failure on develop (fb9d015c), Cargo.lock rustls 0.23.45.
Verification: ran cargo-deny locally, read advisory-db entries (local clone of rustsec/advisory-db), queried crates.io API for 0.23.46, dry-ran `cargo update` in a scratch copy (repo untouched).

## Advisories (all four exist; IDs confirmed; all published 2026-10-14; all patched >= 0.23.46)

| ID | Title | CWE (approx.; RustSec gives category only) | CVSS 3.1 (from advisory) | Affected | jr exposure | jr severity |
|---|---|---|---|---|---|---|
| RUSTSEC-2026-0346 (GHSA-c8m5-c952-6cm4) | Debug impls of client session values expose TLS secrets | CWE-532 | AV:L/AC:H/PR:H/UI:R C:H (low overall, ~3.x-4.x) | >= 0.21.0, < 0.23.46 | Only custom `ClientSessionStore` impls that Debug-format values. jr has none (grep: no ClientSessionStore); reqwest uses rustls's built-in store, which is redacted | Not exposed (LOW/informational) |
| RUSTSEC-2026-0347 (GHSA-vp88-798v-h67f) | App data sent to outer server after ECH rejection | CWE-200 / CWE-696 | AV:L/AC:L/PR:H C:L (~2.x) | >= 0.23.44, < 0.23.46 | Requires `EchMode::Enable`. reqwest 0.13 does not enable ECH; jr sets nothing | Not exposed (LOW) |
| RUSTSEC-2026-0348 (GHSA-h2v8-394m-p7vv) | Brotli cert decompression can allocate 1 GiB pre-auth | CWE-789 | AV:N/AC:H/PR:N A:L (~3.7) | >= 0.23.9, < 0.23.46, ONLY with non-default `brotli` feature | `brotli`/`brotli-decompressor`/`zlib-rs` absent from Cargo.lock (0 matches). Feature not enabled | Not exposed (LOW) |
| RUSTSEC-2026-0349 (GHSA-w44r-93j7-qv28) | Unauthenticated ServerHello can downgrade later connections to classical key exchange | CWE-757 (algorithm downgrade) / CWE-345 | AV:N/AC:H/PR:N C:L (3.7) | all < 0.23.46 | Applies to default client with resumption (reqwest default, in-memory store). Needs on-path attacker, a server that accepts X25519 share without HRR, and the poisoned entry in the SAME process's session store. jr is a short-lived CLI; the store is not persisted across invocations. Impact = loss of post-quantum confidentiality only (no auth bypass, no key compromise); classical X25519 still applies | Technically exposed, LOW (practically negligible) |

CWE numbers are my classification (RustSec lists `categories` only); CVSS vectors are as published in the advisory.

Feature check (`cargo tree -e features -i rustls`): rustls features in use = `aws_lc_rs`, `std`, `tls12`; via hyper-rustls 0.27.7, tokio-rustls 0.26.4, rustls-platform-verifier 0.6.2 (all through reqwest 0.13.4 `rustls`). No brotli, zlib, ech, server-side use. jr is client-only.

## Fix viability
- rustls 0.23.46: published 2026-10-14, NOT yanked, rust_version 1.71 (jr floor 1.88: fine). Minimal fixing version for all four.
- Deps of 0.23.46: rustls-webpki ^0.103.14 (locked 0.103.15, satisfies), rustls-pki-types ^1.12, subtle, zeroize, once_cell. No dependency bump required.
- Scratch-copy test: `cargo update -p rustls --precise 0.23.46` changes ONLY the rustls version + checksum in Cargo.lock (2 lines); `cargo deny check advisories` then reports "advisories ok". Lockfile-only fix is sufficient; no Cargo.toml change. No advisories against rustls-webpki 0.103.15 were reported.
- Not yet verified: `cargo test`/clippy/msrv with 0.23.46 (patch release, expected to be a drop-in); CI will cover.

## Release posture
- origin/main Cargo.toml version 0.7.0; main Cargo.lock locks rustls 0.23.45 and rustls-webpki 0.103.15 (identical to develop). Released v0.7.0 binaries therefore ship the affected rustls.
- Real-world risk to v0.7.0 users is negligible (see table: three not reachable, one low/theoretical).

## Recommendation
1. Land a lockfile-only PR to develop now (`cargo update -p rustls --precise 0.23.46`; chore(deps) commit) - required to unblock the `cargo deny` advisories gate / CI.
2. A dedicated v0.7.1 patch release is NOT warranted on security grounds alone (max jr severity LOW, none CRITICAL/HIGH). Optionally cherry-pick the same 2-line lockfile bump to main via the normal develop->main release flow when the next stable ships; if a hotfix release is cheap, it is acceptable but not required. Mention the rustls bump in the CHANGELOG.
3. No `deny.toml` ignore entries needed (fix is available).
