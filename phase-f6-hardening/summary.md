---
phase: f6-targeted-hardening
bundle: field-dx
cycle: cycle-002
head_sha: 4e4ae4f5
pre_bundle_base: 91d04fe1
merge_commit: dd311e13 (FIX-F6-001 config fix)
issue: "#578, #580"
bc_anchors: []
verification_properties: [VP-578-001..024, VP-580-005..012]
regression_current: 4660/0/106
gate_verdict: GO
date: 2026-08-31
superseded_note: "Replaces the ADF-CODE-MARK-EXCLUSIVITY F6 summary (bundle closed 2026-07-08, PR #593/#594) previously recorded at this path. That bundle's own record remains in factory-artifacts git history at commit 6c6e9141."
---

# Phase F6 — Targeted Hardening Summary (cycle-002, field-dx bundle)

- **Scope:** field-dx delta (GitHub issues #578 + #580; stories S-578-1..4,
  S-580-1), integrated delta `91d04fe1..4e4ae4f5` on `develop`.
- **Date closed:** 2026-08-31.
- **Verdict: F6 COMPLETE.** All gate criteria met or justifiably substituted;
  no CRITICAL/HIGH findings anywhere in this phase.

Full detail per check: `kani-results.md`, `fuzz-results.md`,
`mutation-results.md`, `security-scan-results.md` (all in this directory).

---

## 1. Kani (formal verification)

**Not set up in this repository** — no `kani` dependency, no
`#[kani::proof]` harness anywhere in `src/`/`tests/`. Per CLAUDE.md and this
repo's documented convention (property-style guarantees live as inline
`proptest!` blocks, no standalone VP-NNN registry), the recorded method is
**proptest substitution**, judged sound for this delta: the field-dx surface
is dominated by string parsing, HTTP wire-shape composition, and CLI
arity/dispatch — no unbounded arithmetic, unsafe pointer manipulation, or
array-indexing invariant that would specifically demand a bounded model
checker.

**Coverage: 32/32 field-dx VPs covered, 0 GAPs.** VP-578-016 (JSM
`requestFieldValues` write wire-shape) is PASS-with-caveat: an intentional
parity-PENDING deferral to F4/live-validation by spec design, not an
accidental coverage gap.

## 2. Fuzz testing

**cargo-fuzz not set up** — no `fuzz/` directory, no `fuzz_target!` usage.
Justified **proptest substitution**: all 3 named input-parsing surfaces have
arbitrary-Unicode-input property coverage with no-panic + no-malformed-JSON
oracles, equivalent to what a byte-oriented fuzzer would target for these
bounded pure-string transforms:

- `parse_field_kv` (`NAME[:kind]=VALUE` splitting) — `prop_field_hint_split_no_panic`, `prop_field_hint_value_bytes_preserved`.
- `:asset` `WS:OBJ` composition — `prop_asset_composer_no_malformed_json_ever`.
- `:option` cascading `Parent>Child` split — `prop_cascading_split_no_panic`.

**No uncovered input surface.**

## 3. Mutation testing

Config gap found (`field.rs` + `field_resolve.rs` absent from
`.cargo/mutants.toml::examine_globs`) — **FIXED & MERGED as FIX-F6-001, PR
#749 @ `dd311e13`**. Numeric run on those two files:
177 total mutants; 142 scored → **93 caught, 0 MISSED, 38 timeout (host
contention), 11 unviable**. **Kill rate on conclusively-scored mutants =
93/93 = 100%; zero test-quality-gap survivors.** The remaining six
examine_globs-covered field-dx delta files (`create.rs`, `edit.rs`,
`jsm_create.rs`, `issues.rs`, `requests.rs`, `editmeta.rs`) were
mutation-verified at ≥90% via per-PR required CI at merge time. Full detail:
`mutation-results.md`.

## 4. Security scan

**CLEAN.** `cargo deny check` — advisories/bans/licenses/sources all ok.
`cargo audit` — 0 vulnerability advisories (358 crates scanned). Zero new
third-party dependencies introduced by the delta (`Cargo.toml`/`Cargo.lock`
diff empty). semgrep unavailable in-session; manual CWE/OWASP review
substituted per fallback policy, covering every named new input-handling
entry point. 3 LOW findings, no CRITICAL/HIGH:

- **SEC-F6-1** (CWE-617, `compose_asset_wire` invariant panic) — unreachable
  today; sole production caller always supplies a qualified value. Accepted
  as documented, matches existing codebase invariant-panic convention.
- **SEC-F6-2** (CWE-674, `AllowedValue.children` deserialization-time
  recursion) — runtime tree-walks are guarded at `MAX_FIELD_OPTION_DEPTH =
  256`; raw deserialization depth is bounded only by process stack, same
  accepted-risk class as every other typed API response in the codebase.
  Cross-references the pre-existing tracked item
  `SEC-001-EDITMETA-RECURSION-GUARD`.
- **SEC-F6-3** (CWE-20, `:asset` workspace segment charset) — informational;
  not an injection or SSRF vector (value is JSON-escaped via
  `serde_json::json!`, never concatenated into a URL/host).

Confirmed FIX-F5-001 (`get_issue_types_for_project` pagination bound,
`MAX_CREATEMETA_PAGES = 500`) is a genuine CWE-400/770 fix, no regression.

## 5. Full regression

**PASS.** `cargo test` (full suite) on `develop` @ `4e4ae4f5`: **4660
passed / 0 failed / 106 ignored** (ignored = gated keyring/OAuth/live-E2E
tests), across 111 test-result lines. Zero `FAILED` lines, no panics.

## 6. DTU adversarial testing

**SKIPPED.** `dtu_required: false` — the field-dx bundle clones no external
service behavior; Jira interaction is already covered by wiremock
integration tests.

## 7. Accessibility re-check

**SKIPPED.** `feature_type: backend-cli` — `jr` has no UI surface.

---

## Overall verdict

**F6 COMPLETE.** All applicable gate criteria (formal verification, fuzz
testing, mutation testing, security scan, full regression) are met or
justifiably substituted per repo convention; the two skip categories (DTU,
accessibility) are correctly inapplicable to this CLI-only, no-external-clone
bundle. No CRITICAL/HIGH finding anywhere in the phase. Config-quality gap
found during the phase (mutation `examine_globs` scope) was fixed and merged
within the phase (FIX-F6-001, PR #749), not deferred as tracked debt.

**Next:** Phase F7 (delta convergence — 5-dimensional check on the delta +
full-tree regression — then the FINAL HUMAN GATE to close cycle-002).
