---
phase: f6-targeted-hardening
dimension: security-scans
bundle: ADF-CODE-MARK-EXCLUSIVITY
head_sha: d7875e6
pre_bundle_base: 0d8a8a5
tools:
  - cargo deny check (PASS — advisories/bans/licenses/sources ok)
  - cargo audit (PASS — 347 crates scanned, 0 vulnerabilities)
  - semgrep (SKIP — not installed on host; manual grep audit performed)
  - manual unsafe/unwrap audit of src/adf.rs
findings: 0 CRITICAL, 0 HIGH, 0 MEDIUM, 0 LOW
date: 2026-07-08
verdict: PASS
---

# F6 Dimension 4 — Security Scanning

## 4a. cargo deny check (project standard)

Command: `cargo deny check`

Verbatim tail:

```
warning[license-not-encountered]: license was not encountered
  ┌─ deny.toml:8:6
  │
8 │     "BSD-2-Clause",
  │      ━━━━━━━━━━━━ unmatched license allowance
warning[license-not-encountered]: license was not encountered
   ┌─ deny.toml:15:6
   │
15 │     "OpenSSL",
   │      ━━━━━━━ unmatched license allowance
warning[license-not-encountered]: license was not encountered
   ┌─ deny.toml:13:6
   │
13 │     "Unicode-DFS-2016",
   │      ━━━━━━━━━━━━━━━━ unmatched license allowance

advisories ok, bans ok, licenses ok, sources ok
```

Exit code: **0**

3 non-fatal `license-not-encountered` warnings (unmatched allowances for
`BSD-2-Clause` / `Unicode-DFS-2016` / `OpenSSL`); identical to the
pre-bundle baseline. **No delta-attributable finding.**

## 4b. cargo audit

Command: `cargo audit`

```
Fetching advisory database from `https://github.com/RustSec/advisory-db.git`
      Loaded 1159 security advisories (from /Users/zious/.cargo/advisory-db)
    Updating crates.io index
    Scanning Cargo.lock for vulnerabilities (347 crate dependencies)
```

Exit code: **0** (also verified with `cargo audit --quiet` — no
vulnerabilities emitted). **0 vulnerabilities across 347 crate
dependencies.**

## 4c. Semgrep

Not installed on the host (`which semgrep` → not found). **Justified
skip** — project standard for CI-side static analysis is cargo-deny +
cargo-audit + clippy (`-D warnings`); semgrep is not part of the project
CI pipeline. Precedent: same skip in every prior F6 cycle.

Manual substitute performed on the delta file `src/adf.rs`:

- `grep -nE '^unsafe |^ *unsafe ' src/adf.rs` → **0 real uses** (single hit
  is inside a comment: `sanitized for cell-unsafe characters`).
- Non-test-code `.unwrap()` / `.expect()` count outside the `#[cfg(test)]
  mod tests` block: **4** (unchanged from pre-bundle baseline; delta added
  none).
- No new `panic!(…)` / `unimplemented!()` / `todo!()` outside test code.
- No new file / network / process I/O introduced by the delta (`push_code`
  is a pure-core function; effectful callers are `handle_create` /
  `handle_jsm_create`, unchanged by the delta).

## 4d. Delta scope security review (BC-7.2.015 SEC framing)

The BC body §"Behavior — Security framing" for BC-7.2.015 stipulates two
non-goals that F6 verifies remain non-issues:

1. **No untrusted-input execution**: `push_code` operates on
   `serde_json::Value` mark clones produced upstream by
   `pulldown-cmark` → `AdfBuilder`. The filter is a set-membership test
   on the `type` string; no eval, no dynamic dispatch, no reflection,
   no code-execution surface.
2. **No `href` scheme validation removed or added**: link marks are
   retained verbatim (allowlist keeps `link`). BC-7.2.015 explicitly
   scopes `href` scheme sanitization out (unchanged from the pre-#571
   baseline).

The change is a **restrictive-only** filter (strips marks the ADF schema
already rejected). It cannot introduce a new attack surface; at worst it
could refuse a legitimate mark class, and that regression class is
covered by the VP-571-002 EC-5 link-retention anchor + VP-571-005 JSM
parity Call C.

## Findings

**0 CRITICAL / 0 HIGH / 0 MEDIUM / 0 LOW.**

No `security-reviewer` escalation triggered (only HIGH/CRITICAL findings
trigger the escalation gate). No BLOCK condition.

## Verdict

**PASS** — cargo deny + cargo audit clean; delta introduces no new unsafe
/ I/O / crash surface; BC-7.2.015 security framing preserved.
