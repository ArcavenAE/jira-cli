# F6 Fuzz Testing (cargo-fuzz) — cycle-004 `windows-correctness`

- **Baseline:** `42e92b46` (v0.7.0-dev.4) → **HEAD:** `3b62cefa`
- **Date (UTC):** 2026-09-05
- **Tool:** `cargo-fuzz` — **NOT provisioned** (no `fuzz/` directory; not installed in CI)

## Result: JUSTIFIED SKIP + proptest arbitrary-input substitution

Following the **cycle-002 and cycle-003 precedent**
(`.factory/cycles/cycle-003/phase-f6-hardening/fuzz-results.md`), cargo-fuzz is skipped and the
new input-handling surfaces are covered by `proptest` arbitrary-input generators + example-based
rejection tests.

### Skip justification

1. **No `fuzz/` directory exists.** `ls fuzz/` → absent. No pre-existing libfuzzer targets.
2. **cargo-fuzz is not provisioned** (no `cargo-fuzz` binary, no nightly fuzz toolchain in CI).
3. **The delta introduces no hand-rolled raw-byte-stream parser over attacker-controlled input**
   that would warrant a dedicated fuzz target (contrast the ADF markdown→ADF path or an
   attachment binary decoder). The four parse-shaped surfaces are each either serde-backed or a
   small bounded recognizer, and each already has arbitrary-input proptest coverage.

### New input-handling surfaces → substitution coverage

| Surface | Location | Untrusted input? | Substitution coverage |
|---------|----------|------------------|-----------------------|
| **DPAPI envelope parse** (`encode`/`decode` JSON payload; `wrap`/`unwrap` `JROD` magic + version framing) | `src/api/auth_windows_store.rs` | Reads an on-disk file that DPAPI decrypted — treated as untrusted / possibly-corrupt | **`prop_envelope_encode_decode_round_trip`** (arbitrary access/refresh strings) + **`prop_envelope_wrap_unwrap_round_trip`** (`proptest::collection::vec(any::<u8>(), 0..8000)` — full byte space incl. high bytes). Plus example rejections: structurally-malformed JSON, missing `access`/`refresh` fields, empty input, binary garbage with high bytes, truncated header, bad magic, unrecognized version. Every malformed path yields a distinct typed `Err`, never a panic and never coerced to empty/absent (VP-AUTHDX-014). |
| **tenant_info JSON + body-cap** (`serde_json::from_slice` over a streamed response, bounded to `MAX_TENANT_INFO_RESPONSE_BYTES = 64 KiB` via both `content_length()` pre-check and incremental `body.len()` streaming guard) | `src/api/jira/tenant.rs::fetch_cloud_id` | Yes — HTTP response body from the site URL | serde-backed parse (robustness out of delta scope, same rationale as cycle-003's `env` TOML field). Body-cap boundary is exercised by `tests/cloud_id_tenant_info.rs` (oversized-body soft-fail, malformed-JSON soft-fail, missing-field soft-fail) with a 10 s bounded timeout, `redirect::Policy::none()`, no auth header, and non-`https` scheme → `expect(0)` (zero network requests). Soft-fail invariant: any parse/size/network failure never aborts login and never panics (VP-AUTHDX-019). |
| **profile-name guard** (`reject_unsafe_profile_component`, character-level, never `std::path`) | `src/api/auth_windows_store.rs` | Yes — profile name reaches a filesystem path component | **`prop_reject_unsafe_profile_component_acceptance_implies_opaque_segment`** (arbitrary strings → any accepted name is an opaque single segment). Plus exhaustive example rejection of all 30 reserved device names (incl. Unicode superscript + leading-space stem), both separators everywhere, colon everywhere, embedded NUL, empty/`.`/`..`, trailing dot-or-space; design-conformance test fails on a `std::path` substitution (VP-AUTHDX-016). |
| **cloud_id plausibility** (`is_plausible_cloud_id`, UUID-shape allowlist recognizer over the tenant_info-supplied id) | `src/api/jira/tenant.rs` | Yes — value from the tenant_info response | Example-based rejection over the failure classes: empty string, internal whitespace, whitespace-only, disallowed characters; acceptance of real-UUID shape and existing test-fixture values (`test_is_plausible_cloud_id_*`). A structurally-implausible id is rejected before it can be persisted to the profile. |

### What would have changed this verdict

A new file-format decoder, hand-written protocol parser, or attachment/content sniffer over
untrusted external bytes would have warranted authoring a `libfuzzer` target at
`-max_total_time=300`. No such surface exists in this delta — the envelope framing is a fixed
4-byte-magic + 1-byte-version header whose full byte space is already swept by the 0..8000-byte
`any::<u8>()` proptest, and the two JSON surfaces ride `serde`.

## Verdict

**JUSTIFIED SKIP** — cargo-fuzz not provisioned; no new untrusted-raw-input hand-rolled parser
in the delta. All four new input-handling surfaces have `proptest` arbitrary-input and/or
example-based rejection substitution with the malformed→typed-`Err`-never-panic invariant
proven. **0 uncovered input surface.**
