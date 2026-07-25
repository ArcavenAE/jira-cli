---
phase: f6-targeted-hardening
dimension: fuzz
bundle: SOH-ATTACHMENTS-1
head_sha: db207b81
pre_bundle_base: 9da03d5b
tool: proptest (cargo-fuzz substitute — see choice)
date: 2026-07-24
verdict: PASS
---

# F6 Dimension 2 — Fuzz

## Approach choice + precedent

cargo-fuzz 0.13.1 is installed but the repo has **no `fuzz/` directory** and
has never adopted libFuzzer targets. Consistent with every prior F6 cycle on
this repo, I chose **Approach (a): elevated-cases proptest sweeps over the
delta's pure input-handling functions**, adding a TEMPORARY (uncommitted)
property harness for functions lacking one and reverting it before finishing.
This exercises the same "arbitrary adversarial input → no panic + invariant
holds" surface as a short libFuzzer run without provisioning a new toolchain.

## Delta pure-function inventory + coverage

| Function | Location | Reachable | Fuzz coverage |
|---|---|---|---|
| `sanitize_attachment_filename` | `src/cli/issue/attachments.rs:461` (pub) | external | temp proptest @16384 + existing prop @4096 |
| `display_sanitize_filename` | `src/cli/issue/attachments.rs:279` (pub) | external | temp proptest @16384 |
| `safe_name` (jira) | `src/api/jira/attachments.rs:284` (inline transform) | private | faithful ref-transform proptest @16384 + adversarial unit pins |
| `safe_name` (jsm) | `src/api/jsm/attachments.rs:71` (inline transform) | private | same transform; adversarial unit pins |
| `parse_age_duration` | `src/cli/issue/attachments.rs:2373` (private) | — | Result-returning by construction; unit pins |
| `classify_write_error` | `src/cli/issue/attachments.rs:605` (private) | — | operates on `io::Error`+`Path`; mutant-killing unit pins |
| `write_error_display_strings` | `src/cli/issue/attachments.rs:647` (private) | — | operates on `Path`; mutant-killing unit pins |
| `deserialize_string_or_int_as_string` | `src/api/jira/attachments.rs:32` (private) | — | serde visitor, Result-returning; int/negative/string unit pins |

## Temporary harness (reverted)

`tests/zz_f6_fuzz_temp.rs` (deleted after run; `git status` clean — only the
pre-existing untracked `.claude/` entries remain) ran three proptests, each at
`ProptestConfig::with_cases(16384)` (**49,152 total adversarial inputs**):

1. `fuzz_display_sanitize_no_control_chars` — asserts (a) never panics,
   (b) output contains **no** forbidden codepoint (0x00–0x1F, 0x7F, U+202A..202E,
   U+2066..2069, U+2028, U+2029, U+0085 — the CWE-116 set), (c) 1:1 char-count
   mapping. → **ok**.
2. `fuzz_sanitize_attachment_filename_invariants` — asserts any `Some(name)`
   has no `/`,`\`,`:`,NUL; ≤214 bytes; valid UTF-8; ≠ `"."`/`".."`/empty
   (CWE-22). → **ok**.
3. `fuzz_safe_name_no_injection_chars` — over a faithful re-derivation of the
   production `safe_name` char-map (verified byte-for-byte against
   `src/api/jira/attachments.rs:284` — maps `\r \n \0 " \\` → `_`), asserts no
   CR/LF/NUL/quote/backslash survives (CWE-93 Content-Disposition
   header-injection) + 1:1 char-count. → **ok**.

```
cargo test --test zz_f6_fuzz_temp
test fuzz_safe_name_no_injection_chars ... ok
test fuzz_sanitize_attachment_filename_invariants ... ok
test fuzz_display_sanitize_no_control_chars ... ok
test result: ok. 3 passed; 0 failed; finished in 0.99s
```

## Existing adversarial unit coverage (private functions)

`cargo test --lib` → **1100 passed, 0 failed, 11 ignored**. Relevant pins:
- `safe_name` (jira+jsm): CRLF→`_`, NUL→`_`, `"`→`_`, `\`→`_`, benign pass-through.
- `display_sanitize_filename`: ASCII-control/DEL/bidi (202A-202E, 2066-2069)/line-sep (2028/2029)/NEL (0085)/mixed/passthrough.
- `sanitize_attachment_filename`: relative+absolute traversal, colon-replace, dot/dotdot/empty→None, NUL→None, `NUL.txt` pass-through, long-name truncation, multibyte boundary, trailing dot/space, Windows path + device names (CON/NUL/COM1).
- `deserialize_string_or_int_as_string`: integer, negative-integer, string.
- `parse_age_duration`, `classify_write_error`, `write_error_display_strings`: EC + mutant-killing pins.

## Crashes / panics found

**NONE.** Zero panics or crashes across 49,152 property inputs plus the full
unit suite.

## Verdict

**PASS** — no fuzz crash; every pure input-handling function in the delta is
covered by either an elevated-cases property sweep or comprehensive adversarial
example pins. All three security invariants (CWE-22 disk-path, CWE-116 display,
CWE-93 header-injection) hold over arbitrary input.
